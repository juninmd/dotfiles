#!/bin/bash
c='\e[32m'
r='\e[0m'
# ChatGPT CLI
if ! command -v chatgpt &> /dev/null; then
    echo -e "${c}Installing chatgpt-cli...${r}"
    if command -v npm &> /dev/null; then # NOSONAR
        sudo npm install -g chatgpt-cli # NOSONAR
    else
        echo -e "${c}npm not found, skipping chatgpt-cli installation.${r}" # NOSONAR
    fi
else
    echo -e "${c}chatgpt-cli already installed.${r}"
fi
