#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Lazysql (SQL Client TUI)
if ! command -v lazysql &> /dev/null; then
    printf "%b\n" "${c}Installing lazysql...${r}"
    if command -v go &> /dev/null; then
        go install github.com/jorgerojas26/lazysql@latest
    else
        printf "%b\n" "${c}Go not found, skipping lazysql installation.${r}"
    fi

fi
