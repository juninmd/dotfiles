#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v htop &> /dev/null; then
    printf "%b\n" "${c}Installing htop...${r}"
    sudo apt update
    sudo apt install -y htop
else
    printf "%b\n" "${c}htop is already installed.${r}"
fi
