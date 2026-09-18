#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v mycli &> /dev/null; then
    printf "%b\n" "${c}Installing mycli...${r}"
    if command -v pipx &> /dev/null; then
        pipx install mycli
    else
        pip3 install --break-system-packages mycli
    fi
else
    printf "%b\n" "${c}mycli is already installed.${r}"
fi
