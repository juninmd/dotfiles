#!/bin/bash
c='\e[32m'
r='\e[0m'
# Newsboat (RSS reader)
if ! command -v newsboat &> /dev/null; then
    printf "%b\n" "${c}Installing newsboat...${r}"
    sudo apt install -y newsboat
else
    printf "%b\n" "${c}newsboat already installed.${r}"
fi
