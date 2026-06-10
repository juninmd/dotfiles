#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../common/cargo_helper.sh" 2>/dev/null || { install_cargo_crate() { cargo install "$1"; }; }
echo -e "\e[32mInstalling broot...\e[0m"
install_cargo_crate broot
if command -v broot &> /dev/null; then
    broot --install
fi