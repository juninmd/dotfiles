#!/bin/bash
c='\e[32m'
r='\e[0m'
# Slides (Terminal Presentations)
if ! command -v slides &> /dev/null; then
    echo -e "${c}Installing slides...${r}"
    if command -v go &> /dev/null; then
        go install github.com/maaslalani/slides@latest
    else
        echo -e "${c}Go not found, skipping slides installation.${r}"
    fi
else
    echo -e "${c}slides already installed.${r}"
fi
