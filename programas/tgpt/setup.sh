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
            echo -e "${c}Installing $binary_name...${r}"
            go install "$package"
        else
            echo -e "${c}$binary_name already installed.${r}"
        fi
    }
fi

if ! command -v tgpt &> /dev/null; then
    echo -e "${c}Installing tgpt...${r}"
    install_go_package github.com/aandrew-me/tgpt/v2@latest tgpt
else
    echo -e "${c}tgpt already installed.${r}"
fi
