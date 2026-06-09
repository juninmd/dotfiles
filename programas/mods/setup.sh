#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing mods...${r}"
if command -v go &> /dev/null; then
    go install github.com/charmbracelet/mods@latest
else
    echo -e "${c}Go not found, skipping mods installation.${r}"
fi
