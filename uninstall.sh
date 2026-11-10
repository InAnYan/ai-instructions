#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Uninstalling AI instructions and skills across all supported agents..."
"$SCRIPT_DIR/scripts/uninstall-skills.sh"
echo ""
"$SCRIPT_DIR/scripts/uninstall-agents.sh"
echo ""
echo "Uninstallation complete!"
