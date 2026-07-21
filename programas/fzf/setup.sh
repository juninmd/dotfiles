#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v fzf &> /dev/null; then
    echo -e "${c}Installing fzf...${r}"
    sudo apt install -y fzf # NOSONAR
else
    echo -e "${c}fzf already installed.${r}"
fi
