#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
printf "%b\n" "${c}Installing cline...${r}"
if command -v npm &> /dev/null; then
    sudo npm install -g @cline/cli
else
    printf "%b\n" "${c}npm not found, skipping cline installation.${r}"
fi