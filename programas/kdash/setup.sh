#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing kdash (Kubernetes Dashboard)...${r}"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    install_cargo_crate() {
        local crate="$1"
        cargo install "$crate"
    }
fi

if ! command -v kdash &> /dev/null; then
    install_cargo_crate kdash
else
    echo -e "${c}kdash is already installed.${r}"
fi
