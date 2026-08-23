#!/bin/bash
c='\e[32m'
r='\e[0m'
# Httpstat (Curl statistics made simple)
if ! command -v httpstat &> /dev/null; then
    echo -e "${c}Installing httpstat...${r}"
    pip3 install httpstat --break-system-packages 2>/dev/null || pip3 install httpstat
else
    echo -e "${c}httpstat already installed.${r}"
fi
