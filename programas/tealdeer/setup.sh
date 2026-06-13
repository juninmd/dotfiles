#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
c="\033[1;36m"
r="\033[0m"
source "$SCRIPT_DIR/../common/cargo_helper.sh" 2>/dev/null || { install_cargo_crate() { cargo install "$1"; }; }
echo -e "${c}Installing tealdeer...${r}"
install_cargo_crate tealdeer
if command -v tldr &> /dev/null; then
    tldr --update &> /dev/null &
fi