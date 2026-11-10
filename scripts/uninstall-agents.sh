#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_AGENTS="$REPO_DIR/AGENTS.md"

unlink_agent_file() {
  local target_file="$1"
  local agent_name="$2"

  if [[ -L "$target_file" ]]; then
    local current_link
    current_link="$(readlink "$target_file")"
    if [[ "$current_link" == "$SOURCE_AGENTS" ]]; then
      rm "$target_file"
      echo "[$agent_name] Removed symlink: $target_file"
      if [[ -f "${target_file}.bak" ]]; then
        mv "${target_file}.bak" "$target_file"
        echo "[$agent_name] Restored backup: $target_file"
      fi
    else
      echo "[$agent_name] Skipped $target_file (points to $current_link, not $SOURCE_AGENTS)"
    fi
  elif [[ -e "$target_file" ]]; then
    echo "[$agent_name] Skipped $target_file (not a symlink)"
  fi
}

echo "=== Uninstalling Global AGENTS.md ==="

# 1. Antigravity / Gemini CLI
unlink_agent_file "$HOME/.gemini/config/AGENTS.md" "Antigravity (config)"
unlink_agent_file "$HOME/.gemini/AGENTS.md" "Antigravity (root)"

# 2. Claude Code
unlink_agent_file "$HOME/.claude/CLAUDE.md" "Claude Code (CLAUDE.md)"
unlink_agent_file "$HOME/.claude/AGENTS.md" "Claude Code (AGENTS.md)"

# 3. Standard / Generic agents directory (~/.agents)
unlink_agent_file "$HOME/.agents/AGENTS.md" "Standard Agents (~/.agents)"

echo "Done! Global instructions uninstalled."
