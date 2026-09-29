#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v litecli &> /dev/null; then
    printf "%b\n" "${c}Installing litecli...${r}"
    if command -v pipx &> /dev/null; then
        pipx install litecli
    else
        pip3 install --break-system-packages litecli
    fi
else
    printf "%b\n" "${c}litecli is already installed.${r}"
fi
