#!/bin/bash
c='\e[32m'
r='\e[0m'
# Czg (Interactive Commitizen CLI)
if ! command -v czg &> /dev/null; then
    echo -e "${c}Installing czg...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g czg
    else
        echo -e "${c}npm not found, skipping czg installation.${r}"
    fi
else
    echo -e "${c}czg already installed.${r}"
fi
