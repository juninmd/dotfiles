#!/bin/bash
c='\e[32m'
r='\e[0m'
# Gum (Shell UI)
if ! command -v gum &> /dev/null; then
    echo -e "${c}Installing gum...${r}"
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/gum@latest
    else
        echo -e "${c}Go not found, skipping gum installation.${r}"
    fi
else
    echo -e "${c}gum already installed.${r}"
fi
