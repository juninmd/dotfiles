#!/bin/bash
c='\e[32m'
r='\e[0m'
# Httpie (Modern, user-friendly command-line HTTP client)
if ! command -v http &> /dev/null; then
    printf "%b\n" "${c}Installing httpie...${r}"
    pip3 install httpie --break-system-packages 2>/dev/null || pip3 install httpie
else
    printf "%b\n" "${c}httpie already installed.${r}"
fi
