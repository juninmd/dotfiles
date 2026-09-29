#!/usr/bin/env bash
set -euo pipefail
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing kew...${r}"

if ! command -v kew &> /dev/null; then
    mkdir -p ~/.local/bin
    if command -v eget &> /dev/null; then
        eget ravachol/kew --to ~/.local/bin/kew
    else
        echo -e "${c}eget not found. Skipping kew installation.${r}"
    fi
fi
