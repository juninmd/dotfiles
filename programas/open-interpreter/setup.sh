#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Open-Interpreter (Let language models run code on your computer)
if ! command -v interpreter &> /dev/null; then
    echo -e "${c}Installing open-interpreter...${r}"
    if command -v uv &> /dev/null; then
        uv tool install open-interpreter
    elif command -v pipx &> /dev/null; then
        pipx install open-interpreter
    else
        pip3 install open-interpreter --break-system-packages 2>/dev/null || pip3 install open-interpreter
    fi

fi
