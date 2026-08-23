#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v cmatrix &> /dev/null; then
    echo -e "${c}Installing cmatrix...${r}"
    sudo apt update
    sudo apt install -y cmatrix
else
    echo -e "${c}cmatrix is already installed.${r}"
fi
