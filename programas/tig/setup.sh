#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v tig >/dev/null 2>&1; then
    printf "%b\n" "${c}Installing tig...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y tig
else
    printf "%b\n" "${c}tig already installed.${r}"
fi
