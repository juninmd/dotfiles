#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v ncdu >/dev/null 2>&1; then
    echo -e "${c}Installing ncdu...${r}"
    sudo apt update
    sudo apt install -y ncdu
else
    echo -e "${c}ncdu already installed.${r}"
fi
