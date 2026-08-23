#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v gptme &> /dev/null; then
    echo -e "${c}Installing gptme...${r}"
    if command -v pipx &> /dev/null; then
        pipx install gptme-server
    else
        pip3 install --break-system-packages gptme-server
    fi
else
    echo -e "${c}gptme is already installed.${r}"
fi
