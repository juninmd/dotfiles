#!/bin/bash
c='\e[32m'
r='\e[0m'
# Fx (JSON Viewer)
if ! command -v fx &> /dev/null; then
    printf "%b\n" "${c}Installing fx...${r}"
    if command -v go &> /dev/null; then
        go install github.com/antonmedv/fx@latest
    else
        printf "%b\n" "${c}Go not found, skipping fx installation.${r}"
    fi
else
    printf "%b\n" "${c}fx already installed.${r}"
fi
