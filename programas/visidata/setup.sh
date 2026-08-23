#!/bin/bash
c='\e[32m'
r='\e[0m'
# Visidata (Terminal Spreadsheet)
if ! command -v vd &> /dev/null; then
    echo -e "${c}Installing visidata...${r}"
    pip3 install visidata --break-system-packages 2>/dev/null || pip3 install visidata
else
    echo -e "${c}visidata already installed.${r}"
fi
