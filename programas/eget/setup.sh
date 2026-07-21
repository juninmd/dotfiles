#!/bin/bash
c='\e[32m'
r='\e[0m'
# Eget (Easy Binary Downloader)
if ! command -v eget &> /dev/null; then
    echo -e "${c}Installing eget...${r}"
    curl https://zyedidia.github.io/eget.sh | sh # NOSONAR
    sudo mv eget /usr/local/bin/eget
else
    echo -e "${c}eget already installed.${r}"
fi
