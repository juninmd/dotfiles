#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v htop &> /dev/null; then
    echo -e "${c}Installing htop...${r}"
    sudo apt update
    sudo apt install -y htop
else
    echo -e "${c}htop is already installed.${r}"
fi
