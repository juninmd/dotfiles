#!/bin/bash
c='\e[32m'
r='\e[0m'
# Httpie (Modern, user-friendly command-line HTTP client)
if ! command -v http &> /dev/null; then
    echo -e "${c}Installing httpie...${r}"
    pip3 install httpie --break-system-packages 2>/dev/null || pip3 install httpie
else
    echo -e "${c}httpie already installed.${r}"
fi
