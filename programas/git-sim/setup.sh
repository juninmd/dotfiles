#!/bin/bash
c='\e[32m'
r='\e[0m'
# Git-sim (Visually simulate Git operations)
if ! command -v git-sim &> /dev/null; then
    echo -e "${c}Installing git-sim...${r}"
    python3 -m pip install git-sim --break-system-packages 2>/dev/null || python3 -m pip install git-sim # NOSONAR
else
    echo -e "${c}git-sim already installed.${r}"
fi
