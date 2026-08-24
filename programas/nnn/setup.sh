#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v nnn >/dev/null 2>&1; then
    echo -e "${c}Installing nnn...${r}"
    sudo apt update
    sudo apt install -y nnn
else
    echo -e "${c}nnn already installed.${r}"
fi
