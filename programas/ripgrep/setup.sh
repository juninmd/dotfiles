#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v rg &> /dev/null; then
    printf "%b\n" "${c}Installing ripgrep...${r}"
    sudo apt install -y ripgrep
else
    printf "%b\n" "${c}ripgrep already installed.${r}"
fi
