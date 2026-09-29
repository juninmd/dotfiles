#!/bin/bash
c='\e[32m'
r='\e[0m'
# Eget (Easy Binary Downloader)
if ! command -v eget &> /dev/null; then
    printf "%b\n" "${c}Installing eget...${r}"
    curl https://zyedidia.github.io/eget.sh | sh
    sudo mv eget /usr/local/bin/eget
else
    printf "%b\n" "${c}eget already installed.${r}"
fi
