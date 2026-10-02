#!/bin/bash
c='\e[32m'
r='\e[0m'
# Czg (Interactive Commitizen CLI)
if ! command -v czg &> /dev/null; then
    printf "%b\n" "${c}Installing czg...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g czg
    else
        printf "%b\n" "${c}npm not found, skipping czg installation.${r}"
    fi
else
    printf "%b\n" "${c}czg already installed.${r}"
fi
