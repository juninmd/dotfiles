#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v fzf &> /dev/null; then
    printf "%b\n" "${c}Installing fzf...${r}"
    sudo apt install -y fzf
else
    printf "%b\n" "${c}fzf already installed.${r}"
fi
