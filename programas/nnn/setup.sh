#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v nnn >/dev/null 2>&1; then
    echo -e "${c}Installing nnn...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y nnn
else
    echo -e "${c}nnn already installed.${r}"
fi
