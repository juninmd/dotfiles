#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Aider-chat (AI pair programming)
if ! command -v aider &> /dev/null; then
    echo -e "${c}Installing aider-chat...${r}"
    python3 -m pip install aider-chat --break-system-packages 2>/dev/null || python3 -m pip install aider-chat # NOSONAR
else
    echo -e "${c}aider-chat already installed.${r}"
fi
