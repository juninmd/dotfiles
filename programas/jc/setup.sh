#!/bin/bash
c='\e[32m'
r='\e[0m'
# JC (Converts output of popular command-line tools and file-types to JSON)
if ! command -v jc &> /dev/null; then
    echo -e "${c}Installing jc...${r}"
    sudo apt install -y jc # NOSONAR
else
    echo -e "${c}jc already installed.${r}"
fi
