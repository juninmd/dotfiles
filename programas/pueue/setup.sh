#!/usr/bin/env bash
set -euo pipefail
c="\033[1;36m"
r="\033[0m"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../common/cargo_helper.sh" 2>/dev/null || { install_cargo_crate() { cargo install "$1"; }; }
echo -e "${c}Installing pueue...${r}"
install_cargo_crate pueue