#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILLS="$REPO_DIR/skills"

if [[ ! -d "$SOURCE_SKILLS" ]]; then
  echo "Error: $SOURCE_SKILLS directory does not exist." >&2
  exit 1
fi

link_skills_dir() {
  local target_link="$1"
  local agent_name="$2"
  local parent_dir
  parent_dir="$(dirname "$target_link")"
  mkdir -p "$parent_dir"

  if [[ -L "$target_link" ]]; then
    local current_link
    current_link="$(readlink "$target_link")"
    if [[ "$current_link" == "$SOURCE_SKILLS" ]]; then
      echo "[$agent_name] Already linked: $target_link -> $SOURCE_SKILLS"
      return 0
    fi
    echo "[$agent_name] Updating symlink: $target_link"
    rm "$target_link"
  elif [[ -d "$target_link" ]]; then
    echo "[$agent_name] Backing up existing directory $target_link to ${target_link}.bak"
    mv "$target_link" "${target_link}.bak"
  fi

  ln -s "$SOURCE_SKILLS" "$target_link"
  echo "[$agent_name] Linked: $target_link -> $SOURCE_SKILLS"
}

update_json_add_entry() {
  local json_file="$1"
  local entry_path="$2"
  local parent_dir
  parent_dir="$(dirname "$json_file")"
  mkdir -p "$parent_dir"

  if [[ ! -f "$json_file" ]] || [[ ! -s "$json_file" ]]; then
    echo '{"entries": []}' > "$json_file"
  fi

  local tmp_file
  tmp_file="$(mktemp "${json_file}.tmp.XXXXXX")"

  if command -v jq >/dev/null 2>&1; then
    jq --arg p "$entry_path" '
      .entries = (((.entries // []) + [{"path": $p}]) | unique_by(.path))
    ' "$json_file" > "$tmp_file"
  else
    python3 -c "
import json, sys
fpath, p = sys.argv[1], sys.argv[2]
try:
    with open(fpath, 'r') as f:
        data = json.load(f)
except Exception:
    data = {}
entries = data.get('entries', [])
if not any(e.get('path') == p for e in entries):
    entries.append({'path': p})
data['entries'] = entries
with open(sys.argv[3], 'w') as f:
    json.dump(data, f, indent=2)
" "$json_file" "$entry_path" "$tmp_file"
  fi

  mv "$tmp_file" "$json_file"
  echo "[Antigravity] Updated $json_file with entry: $entry_path"
}

echo "=== Installing Skills across AI Coding Agents ==="

# 1. Antigravity / Gemini CLI: register path in skills.json and symlink folder
GEMINI_CONFIG_DIR="$HOME/.gemini/config"
update_json_add_entry "$GEMINI_CONFIG_DIR/skills.json" "$SOURCE_SKILLS"
link_skills_dir "$GEMINI_CONFIG_DIR/skills" "Antigravity (config/skills)"

# 2. Claude Code: symlink to ~/.claude/skills
link_skills_dir "$HOME/.claude/skills" "Claude Code (~/.claude/skills)"

# 3. Standard / Generic agents: symlink to ~/.agents/skills
link_skills_dir "$HOME/.agents/skills" "Standard Agents (~/.agents/skills)"

echo "Done! Skills installed successfully."
