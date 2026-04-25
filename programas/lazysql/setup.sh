#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Lazysql (SQL Client TUI)
if ! command -v lazysql &> /dev/null; then
    echo -e "${c}Installing lazysql...${r}"
    if command -v go &> /dev/null; then
        go install github.com/jorgerojas26/lazysql@latest
    else
        echo -e "${c}Go not found, skipping lazysql installation.${r}"
    fi

fi
