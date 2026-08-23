#!/bin/bash
c='\e[32m'
r='\e[0m'
# Direnv (Environment variable manager)
if ! command -v direnv &> /dev/null; then
    echo -e "${c}Installing direnv...${r}"
    sudo apt install -y direnv
else
    echo -e "${c}direnv already installed.${r}"
fi
