#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    install_cargo_crate() {
        local crate="$1"
        if ! command -v "$crate" &> /dev/null; then
            printf "%b\n" "${c}Installing $crate...${r}"
            cargo install "$crate"
        else
            printf "%b\n" "${c}$crate already installed.${r}"
        fi
    }
fi

if ! command -v aichat &> /dev/null; then
    printf "%b\n" "${c}Installing aichat...${r}"
    install_cargo_crate aichat
else
    printf "%b\n" "${c}aichat already installed.${r}"
fi
