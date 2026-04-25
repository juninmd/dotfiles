#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Repomix (Pack repository into AI prompt)
if ! command -v repomix &> /dev/null; then
    echo -e "${c}Installing repomix...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g repomix
    else
        echo -e "${c}npm not found, skipping repomix installation.${r}"
    fi

fi
