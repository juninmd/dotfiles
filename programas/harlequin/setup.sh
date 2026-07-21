#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Harlequin (SQL IDE for terminal)
if ! command -v harlequin &> /dev/null; then
    echo -e "${c}Installing harlequin...${r}"
    python3 -m pip install harlequin --break-system-packages 2>/dev/null || python3 -m pip install harlequin # NOSONAR
else
    echo -e "${c}harlequin already installed.${r}"
fi
