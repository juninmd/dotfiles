#!/bin/bash
c='\e[32m'
r='\e[0m'
# Shellcheck (Shell script analysis tool)
if ! command -v shellcheck &> /dev/null; then
    printf "%b\n" "${c}Installing shellcheck...${r}"
    sudo apt install -y shellcheck
else
    printf "%b\n" "${c}shellcheck already installed.${r}"
fi
