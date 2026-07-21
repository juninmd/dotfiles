#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing ruff...${r}"
if command -v uv > /dev/null 2>&1; then
    uv tool install ruff
else
    python3 -m pip install ruff --break-system-packages # NOSONAR
fi