#!/bin/bash
c='\e[32m'
r='\e[0m'
# Direnv (Environment variable manager)
if ! command -v direnv &> /dev/null; then
    printf "%b\n" "${c}Installing direnv...${r}"
    sudo apt install -y direnv
else
    printf "%b\n" "${c}direnv already installed.${r}"
fi
