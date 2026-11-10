#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing AI instructions and skills across all supported agents..."
"$SCRIPT_DIR/scripts/install-agents.sh"
echo ""
"$SCRIPT_DIR/scripts/install-skills.sh"
echo ""
echo "Installation complete!"
