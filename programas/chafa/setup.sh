#!/bin/bash
c='\e[32m'
r='\e[0m'
# Chafa (Terminal graphics)
if ! command -v chafa &> /dev/null; then
    printf "%b\n" "${c}Installing chafa...${r}"
    sudo apt install -y chafa
else
    printf "%b\n" "${c}chafa already installed.${r}"
fi
