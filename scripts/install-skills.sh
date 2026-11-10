#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILLS="$REPO_DIR/skills"

if [[ ! -d "$SOURCE_SKILLS" ]]; then
  echo "Error: $SOURCE_SKILLS directory does not exist." >&2
  exit 1
fi

# Link individual skill subdirectories into the target skills directory
link_individual_skills() {
  local target_dir="$1"
  local agent_name="$2"

  # If target_dir is a symlink (e.g. from a legacy install), remove it safely
  if [[ -L "$target_dir" ]]; then
    echo "[$agent_name] Converting directory symlink $target_dir into a real directory..."
    rm "$target_dir"
  fi

  mkdir -p "$target_dir"

  for skill_path in "$SOURCE_SKILLS"/*; do
    [[ -d "$skill_path" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_path")"
    local dest_skill="$target_dir/$skill_name"

    if [[ -L "$dest_skill" ]]; then
      local current_target
      current_target="$(readlink "$dest_skill")"
      if [[ "$current_target" == "$skill_path" ]]; then
        echo "[$agent_name] Skill '$skill_name' already linked."
        continue
      else
        echo "[$agent_name] Updating symlink for '$skill_name' -> $skill_path"
        rm "$dest_skill"
      fi
    elif [[ -e "$dest_skill" ]]; then
      echo "[$agent_name] WARNING: '$skill_name' already exists in $target_dir and is not our symlink. Skipping." >&2
      continue
    fi

    ln -s "$skill_path" "$dest_skill"
    echo "[$agent_name] Linked skill: $skill_name"
  done
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
  echo "[Antigravity] Registered path in $json_file"
}

echo "=== Installing Skills across AI Coding Agents ==="

# 1. Antigravity / Gemini CLI: register path in skills.json and link individual skills
GEMINI_CONFIG_DIR="$HOME/.gemini/config"
update_json_add_entry "$GEMINI_CONFIG_DIR/skills.json" "$SOURCE_SKILLS"
link_individual_skills "$GEMINI_CONFIG_DIR/skills" "Antigravity"

# 2. Claude Code: link individual skills into ~/.claude/skills
link_individual_skills "$HOME/.claude/skills" "Claude Code"

# 3. Standard / Generic agents: link individual skills into ~/.agents/skills
link_individual_skills "$HOME/.agents/skills" "Standard Agents"

echo "Done! Skills installed successfully."
