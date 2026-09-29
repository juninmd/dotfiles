#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Repomix (Pack repository into AI prompt)
if ! command -v repomix &> /dev/null; then
    printf "%b\n" "${c}Installing repomix...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g repomix
    else
        printf "%b\n" "${c}npm not found, skipping repomix installation.${r}"
    fi

fi
