#!/bin/bash
c='\e[32m'
r='\e[0m'
# Duf (Disk Usage/Free)
if ! command -v duf &> /dev/null; then
    printf "%b\n" "${c}Installing duf...${r}"
    if command -v go &> /dev/null; then
        go install github.com/muesli/duf@latest
    else
        printf "%b\n" "${c}Go not found, skipping duf installation via go install.${r}"
    fi
else
    printf "%b\n" "${c}duf already installed.${r}"
fi
