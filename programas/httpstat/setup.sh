#!/bin/bash
c='\e[32m'
r='\e[0m'
# Httpstat (Curl statistics made simple)
if ! command -v httpstat &> /dev/null; then
    echo -e "${c}Installing httpstat...${r}"
    python3 -m pip install httpstat --break-system-packages 2>/dev/null || python3 -m pip install httpstat # NOSONAR
else
    echo -e "${c}httpstat already installed.${r}"
fi
