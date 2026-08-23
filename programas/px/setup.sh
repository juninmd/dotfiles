#!/bin/bash
c='\e[32m'
r='\e[0m'
# Px (ps and top for Human Beings)
if ! command -v px &> /dev/null; then
    echo -e "${c}Installing px...${r}"
    if command -v uv &> /dev/null; then
        uv tool install px-command
    else
        pip3 install px-command --break-system-packages 2>/dev/null || pip3 install px-command
    fi
else
    echo -e "${c}px already installed.${r}"
fi
