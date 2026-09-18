#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Harlequin (SQL IDE for terminal)
if ! command -v harlequin &> /dev/null; then
    printf "%b\n" "${c}Installing harlequin...${r}"
    pip3 install harlequin --break-system-packages 2>/dev/null || pip3 install harlequin
else
    printf "%b\n" "${c}harlequin already installed.${r}"
fi
