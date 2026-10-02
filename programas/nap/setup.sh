#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

printf "%b\n" "${c}Installing nap (Snippets Manager)...${r}"

if ! command -v nap &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/nap@latest
        printf "%b\n" "${c}nap installed successfully via go.${r}"
    else
        printf "%b\n" "${c}Go not found. Unable to install nap.${r}"
    fi
else
    printf "%b\n" "${c}nap is already installed.${r}"
fi
