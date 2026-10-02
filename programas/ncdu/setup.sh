#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v ncdu >/dev/null 2>&1; then
    printf "%b\n" "${c}Installing ncdu...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ncdu
else
    printf "%b\n" "${c}ncdu already installed.${r}"
fi
