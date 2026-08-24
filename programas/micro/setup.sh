#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v micro >/dev/null 2>&1; then
    echo -e "${c}Installing micro...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y micro
else
    echo -e "${c}micro already installed.${r}"
fi
