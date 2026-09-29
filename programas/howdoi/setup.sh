#!/bin/bash
c='\e[32m'
r='\e[0m'
# howdoi (Instant coding answers)
if ! command -v howdoi &> /dev/null; then
    printf "%b\n" "${c}Installing howdoi...${r}"
    if command -v uv &> /dev/null; then
        uv tool install howdoi
    else
        pip3 install howdoi --break-system-packages 2>/dev/null || pip3 install howdoi
    fi
else
    printf "%b\n" "${c}howdoi already installed.${r}"
fi
