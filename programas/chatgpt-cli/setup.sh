#!/bin/bash
c='\e[32m'
r='\e[0m'
# ChatGPT CLI
if ! command -v chatgpt &> /dev/null; then
    printf "%b\n" "${c}Installing chatgpt-cli...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g chatgpt-cli
    else
        printf "%b\n" "${c}npm not found, skipping chatgpt-cli installation.${r}"
    fi
else
    printf "%b\n" "${c}chatgpt-cli already installed.${r}"
fi
