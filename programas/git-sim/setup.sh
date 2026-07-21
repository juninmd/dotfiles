#!/bin/bash
c='\e[32m'
r='\e[0m'
# Git-sim (Visually simulate Git operations)
if ! command -v git-sim &> /dev/null; then
    echo -e "${c}Installing git-sim...${r}"
    pip3 install git-sim --break-system-packages 2>/dev/null || pip3 install git-sim
else
    echo -e "${c}git-sim already installed.${r}"
fi
