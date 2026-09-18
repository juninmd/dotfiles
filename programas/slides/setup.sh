#!/bin/bash
c='\e[32m'
r='\e[0m'
# Slides (Terminal Presentations)
if ! command -v slides &> /dev/null; then
    printf "%b\n" "${c}Installing slides...${r}"
    if command -v go &> /dev/null; then
        go install github.com/maaslalani/slides@latest
    else
        printf "%b\n" "${c}Go not found, skipping slides installation.${r}"
    fi
else
    printf "%b\n" "${c}slides already installed.${r}"
fi
