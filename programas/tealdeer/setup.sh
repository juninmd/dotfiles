#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing tealdeer...${r}"
install_cargo_crate tealdeer tldr
if command -v tldr &> /dev/null; then
    tldr --update &> /dev/null &
fi
