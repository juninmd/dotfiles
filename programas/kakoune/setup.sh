#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v kak >/dev/null 2>&1; then
    printf "%b\n" "${c}Installing kakoune...${r}"
    sudo apt update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt install -y kakoune
else
    printf "%b\n" "${c}kakoune already installed.${r}"
fi
