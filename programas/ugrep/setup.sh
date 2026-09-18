#!/bin/bash
c='\e[32m'
r='\e[0m'
# Ugrep (Ultra fast grep)
if ! command -v ugrep &> /dev/null; then
    printf "%b\n" "${c}Installing ugrep...${r}"
    sudo apt install -y ugrep
else
    printf "%b\n" "${c}ugrep already installed.${r}"
fi
