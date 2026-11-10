#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILLS="$REPO_DIR/skills"

unlink_individual_skills() {
  local target_dir="$1"
  local agent_name="$2"

  if [[ ! -d "$target_dir" ]]; then
    return 0
  fi

  for skill_path in "$SOURCE_SKILLS"/*; do
    [[ -d "$skill_path" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_path")"
    local dest_skill="$target_dir/$skill_name"

    if [[ -L "$dest_skill" ]]; then
      local current_target
      current_target="$(readlink "$dest_skill")"
      if [[ "$current_target" == "$skill_path" ]]; then
        rm "$dest_skill"
        echo "[$agent_name] Removed skill symlink: $skill_name"
      else
        echo "[$agent_name] Skipped $skill_name (points to $current_target, not $skill_path)"
      fi
    fi
  done
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
unlink_individual_skills "$GEMINI_CONFIG_DIR/skills" "Antigravity"

# 2. Claude Code
unlink_individual_skills "$HOME/.claude/skills" "Claude Code"

# 3. Standard / Generic agents
unlink_individual_skills "$HOME/.agents/skills" "Standard Agents"

echo "Done! Skills uninstalled successfully."
