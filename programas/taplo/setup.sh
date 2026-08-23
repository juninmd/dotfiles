#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing taplo...${r}"

# Source cargo helper to get install_cargo_crate
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    echo -e "${c}Warning: cargo_helper.sh not found. Defining fallback function.${r}"
    install_cargo_crate() {
        local crate="$1"
        cargo install "$crate"
    }
fi

install_cargo_crate "taplo-cli"
echo -e "${c}taplo installed.${r}"
