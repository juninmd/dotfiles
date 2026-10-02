#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh" 2>/dev/null || {
    install_cargo_crate() { cargo install "$1"; }
}

if ! command -v tere &> /dev/null; then
    printf "%b\n" "${c}Installing tere...${r}"
    install_cargo_crate tere
else
    printf "%b\n" "${c}tere is already installed.${r}"
fi
