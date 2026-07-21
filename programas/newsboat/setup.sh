#!/bin/bash
c='\e[32m'
r='\e[0m'
# Newsboat (RSS reader)
if ! command -v newsboat &> /dev/null; then
    echo -e "${c}Installing newsboat...${r}"
    sudo apt install -y newsboat # NOSONAR
else
    echo -e "${c}newsboat already installed.${r}"
fi
