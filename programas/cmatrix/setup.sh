#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v cmatrix &> /dev/null; then
    printf "%b\n" "${c}Installing cmatrix...${r}"
    sudo apt update
    sudo apt install -y cmatrix
else
    printf "%b\n" "${c}cmatrix is already installed.${r}"
fi
