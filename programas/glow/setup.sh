#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing glow (Markdown Renderer)...${r}"

if ! command -v glow &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/glow@latest
        echo -e "${c}glow installed successfully via go.${r}"
    else
        echo -e "${c}Go not found. Unable to install glow.${r}"
        #exit 1
    fi
else
    echo -e "${c}glow is already installed.${r}"
fi
