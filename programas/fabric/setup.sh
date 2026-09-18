#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    install_go_package() {
        local package="$1"
        local binary_name="${2:-$(basename "${package%%@*}")}"
        if ! command -v "$binary_name" &> /dev/null; then
            printf "%b\n" "${c}Installing $binary_name...${r}"
            go install "$package"
        else
            printf "%b\n" "${c}$binary_name already installed.${r}"
        fi
    }
fi

if ! command -v fabric &> /dev/null; then
    printf "%b\n" "${c}Installing fabric...${r}"
    install_go_package github.com/danielmiessler/fabric@latest fabric
else
    printf "%b\n" "${c}fabric already installed.${r}"
fi
