#!/bin/bash
c='\e[32m'
r='\e[0m'
# Tldr (Fast tldr client in C)
if ! command -v tldr &> /dev/null; then
    echo -e "${c}Installing tldr...${r}"
    sudo apt install -y tldr
else
    echo -e "${c}tldr already installed.${r}"
fi
