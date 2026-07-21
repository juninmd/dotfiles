#!/bin/bash
c='\e[32m'
r='\e[0m'
# Lnav (Log Navigator)
if ! command -v lnav &> /dev/null; then
    echo -e "${c}Installing lnav...${r}"
    sudo apt install -y lnav # NOSONAR
else
    echo -e "${c}lnav already installed.${r}"
fi
