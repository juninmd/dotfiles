#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    ./ "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    install_cargo_crate() {
        local crate="$1"
        if ! command -v "$crate" &> /dev/null; then
            echo -e "${c}Installing $crate...${r}"
            cargo install "$crate"
        else
            echo -e "${c}$crate already installed.${r}"
        fi
    }
fi

if ! command -v aichat &> /dev/null; then
    echo -e "${c}Installing aichat...${r}"
    install_cargo_crate aichat
else
    echo -e "${c}aichat already installed.${r}"
fi
