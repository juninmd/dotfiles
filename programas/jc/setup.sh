#!/bin/bash
c='\e[32m'
r='\e[0m'
# JC (Converts output of popular command-line tools and file-types to JSON)
if ! command -v jc &> /dev/null; then
    printf "%b\n" "${c}Installing jc...${r}"
    sudo apt install -y jc
else
    printf "%b\n" "${c}jc already installed.${r}"
fi
