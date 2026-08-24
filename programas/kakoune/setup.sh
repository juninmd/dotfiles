#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v kak >/dev/null 2>&1; then
    echo -e "${c}Installing kakoune...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y kakoune
else
    echo -e "${c}kakoune already installed.${r}"
fi
