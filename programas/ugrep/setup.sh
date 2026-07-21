#!/bin/bash
c='\e[32m'
r='\e[0m'
# Ugrep (Ultra fast grep)
if ! command -v ugrep &> /dev/null; then
    echo -e "${c}Installing ugrep...${r}"
    sudo apt install -y ugrep # NOSONAR
else
    echo -e "${c}ugrep already installed.${r}"
fi
