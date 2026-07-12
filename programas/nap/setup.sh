#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing nap (Snippets Manager)...${r}"

if ! command -v nap &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/nap@latest
        echo -e "${c}nap installed successfully via go.${r}"
    else
        echo -e "${c}Go not found. Unable to install nap.${r}"
    fi
else
    echo -e "${c}nap is already installed.${r}"
fi
