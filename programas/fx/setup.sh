#!/bin/bash
c='\e[32m'
r='\e[0m'
# Fx (JSON Viewer)
if ! command -v fx &> /dev/null; then
    echo -e "${c}Installing fx...${r}"
    if command -v go &> /dev/null; then
        go install github.com/antonmedv/fx@latest
    else
        echo -e "${c}Go not found, skipping fx installation.${r}"
    fi
else
    echo -e "${c}fx already installed.${r}"
fi
