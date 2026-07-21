#!/bin/bash
c='\e[32m'
r='\e[0m'
# Px (ps and top for Human Beings)
if ! command -v px &> /dev/null; then
    echo -e "${c}Installing px...${r}"
    if command -v uv &> /dev/null; then
        uv tool install px-command
    else
        python3 -m pip install px-command --break-system-packages 2>/dev/null || python3 -m pip install px-command # NOSONAR
    fi
else
    echo -e "${c}px already installed.${r}"
fi
