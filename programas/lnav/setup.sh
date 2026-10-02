#!/bin/bash
c='\e[32m'
r='\e[0m'
# Lnav (Log Navigator)
if ! command -v lnav &> /dev/null; then
    printf "%b\n" "${c}Installing lnav...${r}"
    sudo apt install -y lnav
else
    printf "%b\n" "${c}lnav already installed.${r}"
fi
