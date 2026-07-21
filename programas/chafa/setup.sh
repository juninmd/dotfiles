#!/bin/bash
c='\e[32m'
r='\e[0m'
# Chafa (Terminal graphics)
if ! command -v chafa &> /dev/null; then
    echo -e "${c}Installing chafa...${r}"
    sudo apt install -y chafa
else
    echo -e "${c}chafa already installed.${r}"
fi
