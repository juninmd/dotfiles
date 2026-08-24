#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v tig >/dev/null 2>&1; then
    echo -e "${c}Installing tig...${r}"
    sudo apt update
    sudo apt install -y tig
else
    echo -e "${c}tig already installed.${r}"
fi
