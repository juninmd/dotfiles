#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    install_cargo_crate() {
        cargo install "$1"
    }
fi

# Atuin (Magical Shell History)
if ! command -v atuin &> /dev/null; then
    echo -e "${c}Installing atuin...${r}"
    install_cargo_crate atuin
else
    echo -e "${c}atuin already installed.${r}"
fi