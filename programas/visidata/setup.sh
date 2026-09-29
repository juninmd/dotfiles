#!/bin/bash
c='\e[32m'
r='\e[0m'
# Visidata (Terminal Spreadsheet)
if ! command -v vd &> /dev/null; then
    printf "%b\n" "${c}Installing visidata...${r}"
    pip3 install visidata --break-system-packages 2>/dev/null || pip3 install visidata
else
    printf "%b\n" "${c}visidata already installed.${r}"
fi
