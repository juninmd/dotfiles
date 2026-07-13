#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v rg &> /dev/null; then
    echo -e "${c}Installing ripgrep...${r}"
    sudo apt install -y ripgrep
else
    echo -e "${c}ripgrep already installed.${r}"
fi
