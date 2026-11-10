#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_AGENTS="$REPO_DIR/AGENTS.md"

if [[ ! -f "$SOURCE_AGENTS" ]]; then
  echo "Error: $SOURCE_AGENTS does not exist." >&2
  exit 1
fi

link_agent_file() {
  local target_dir="$1"
  local target_file="$target_dir/$2"
  local agent_name="$3"

  mkdir -p "$target_dir"

  if [[ -L "$target_file" ]]; then
    local current_link
    current_link="$(readlink "$target_file")"
    if [[ "$current_link" == "$SOURCE_AGENTS" ]]; then
      echo "[$agent_name] Already linked: $target_file -> $SOURCE_AGENTS"
      return 0
    fi
    echo "[$agent_name] Updating symlink: $target_file"
    rm "$target_file"
  elif [[ -f "$target_file" ]]; then
    echo "[$agent_name] Backing up existing $target_file to $target_file.bak"
    mv "$target_file" "$target_file.bak"
  fi

  ln -s "$SOURCE_AGENTS" "$target_file"
  echo "[$agent_name] Linked: $target_file -> $SOURCE_AGENTS"
}

echo "=== Installing Global AGENTS.md across AI Coding Agents ==="

# 1. Antigravity / Gemini CLI
link_agent_file "$HOME/.gemini/config" "AGENTS.md" "Antigravity (config)"
link_agent_file "$HOME/.gemini" "AGENTS.md" "Antigravity (root)"

# 2. Claude Code
link_agent_file "$HOME/.claude" "CLAUDE.md" "Claude Code (CLAUDE.md)"
link_agent_file "$HOME/.claude" "AGENTS.md" "Claude Code (AGENTS.md)"

# 3. Standard / Generic agents directory (~/.agents)
link_agent_file "$HOME/.agents" "AGENTS.md" "Standard Agents (~/.agents)"

echo "Done! Global instructions installed."
