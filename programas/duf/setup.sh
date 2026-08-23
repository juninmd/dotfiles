#!/bin/bash
c='\e[32m'
r='\e[0m'
# Duf (Disk Usage/Free)
if ! command -v duf &> /dev/null; then
    echo -e "${c}Installing duf...${r}"
    if command -v go &> /dev/null; then
        go install github.com/muesli/duf@latest
    else
        echo -e "${c}Go not found, skipping duf installation via go install.${r}"
    fi
else
    echo -e "${c}duf already installed.${r}"
fi
