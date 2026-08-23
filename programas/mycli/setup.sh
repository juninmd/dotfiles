#!/bin/bash
c='\e[32m'
r='\e[0m'
if ! command -v mycli &> /dev/null; then
    echo -e "${c}Installing mycli...${r}"
    if command -v pipx &> /dev/null; then
        pipx install mycli
    else
        python3 -m pip install --break-system-packages mycli
    fi
else
    echo -e "${c}mycli is already installed.${r}"
fi
