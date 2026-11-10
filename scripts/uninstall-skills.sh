#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILLS="$REPO_DIR/skills"

unlink_skills_dir() {
  local target_link="$1"
  local agent_name="$2"

  if [[ -L "$target_link" ]]; then
    local current_link
    current_link="$(readlink "$target_link")"
    if [[ "$current_link" == "$SOURCE_SKILLS" ]]; then
      rm "$target_link"
      echo "[$agent_name] Removed symlink: $target_link"
      if [[ -d "${target_link}.bak" ]]; then
        mv "${target_link}.bak" "$target_link"
        echo "[$agent_name] Restored backup: $target_link"
      fi
    else
      echo "[$agent_name] Skipped $target_link (points to $current_link, not $SOURCE_SKILLS)"
    fi
  elif [[ -e "$target_link" ]]; then
    echo "[$agent_name] Skipped $target_link (not a symlink)"
  fi
}

update_json_remove_entry() {
  local json_file="$1"
  local entry_path="$2"

  if [[ ! -f "$json_file" ]]; then
    return 0
  fi

  local tmp_file
  tmp_file="$(mktemp "${json_file}.tmp.XXXXXX")"

  if command -v jq >/dev/null 2>&1; then
    jq --arg p "$entry_path" '
      .entries = [ (.entries // [])[] | select(.path != $p) ]
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
entries = [e for e in data.get('entries', []) if e.get('path') != p]
data['entries'] = entries
with open(sys.argv[3], 'w') as f:
    json.dump(data, f, indent=2)
" "$json_file" "$entry_path" "$tmp_file"
  fi

  mv "$tmp_file" "$json_file"
  echo "[Antigravity] Removed $entry_path from $json_file"
}

echo "=== Uninstalling Skills ==="

# 1. Antigravity / Gemini CLI
GEMINI_CONFIG_DIR="$HOME/.gemini/config"
update_json_remove_entry "$GEMINI_CONFIG_DIR/skills.json" "$SOURCE_SKILLS"
unlink_skills_dir "$GEMINI_CONFIG_DIR/skills" "Antigravity (config/skills)"

# 2. Claude Code
unlink_skills_dir "$HOME/.claude/skills" "Claude Code (~/.claude/skills)"

# 3. Standard / Generic agents
unlink_skills_dir "$HOME/.agents/skills" "Standard Agents (~/.agents/skills)"

echo "Done! Skills uninstalled successfully."
