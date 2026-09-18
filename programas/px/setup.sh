#!/bin/bash
c='\e[32m'
r='\e[0m'
# Px (ps and top for Human Beings)
if ! command -v px &> /dev/null; then
    printf "%b\n" "${c}Installing px...${r}"
    if command -v uv &> /dev/null; then
        uv tool install px-command
    else
        pip3 install px-command --break-system-packages 2>/dev/null || pip3 install px-command
    fi
else
    printf "%b\n" "${c}px already installed.${r}"
fi
