#!/bin/bash
c='\e[32m'
r='\e[0m'
# Shellcheck (Shell script analysis tool)
if ! command -v shellcheck &> /dev/null; then
    echo -e "${c}Installing shellcheck...${r}"
    sudo apt install -y shellcheck
else
    echo -e "${c}shellcheck already installed.${r}"
fi
