#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v gptme &> /dev/null; then
    printf "%b\n" "${c}Installing gptme...${r}"
    if command -v pipx &> /dev/null; then
        pipx install gptme-server
    else
        pip3 install --break-system-packages gptme-server
    fi
else
    printf "%b\n" "${c}gptme is already installed.${r}"
fi
