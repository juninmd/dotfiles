#!/bin/bash
c='\e[32m'
r='\e[0m'

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    # Fallback
    install_cargo_crate() { cargo install "$1"; }
    install_go_package() { go install "$1"; }
fi

echo -e "${c}Installing d2...${r}"\ncurl -fsSL https://d2lang.com/install.sh | sh -s --
