#!/bin/bash
c='\e[32m'
r='\e[0m'
# The Fuck (Command Corrector)
if ! command -v thefuck &> /dev/null; then
    printf "%b\n" "${c}Installing thefuck...${r}"
    pip3 install thefuck --break-system-packages 2>/dev/null || pip3 install thefuck
else
    printf "%b\n" "${c}thefuck already installed.${r}"
fi
