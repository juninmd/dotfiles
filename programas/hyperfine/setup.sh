#!/bin/sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../common/cargo_helper.sh" 2>/dev/null || { install_cargo_crate() { cargo install "$1"; }; }
echo -e "\e[32mInstalling Hyperfine...\e[0m"
install_cargo_crate hyperfine
