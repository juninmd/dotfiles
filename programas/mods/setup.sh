#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
printf "%b\n" "${c}Installing mods...${r}"
if command -v go &> /dev/null; then
    install_go_package github.com/charmbracelet/mods@latest
else
    printf "%b\n" "${c}Go not found, skipping mods installation.${r}"
fi