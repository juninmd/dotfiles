#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Aider-chat (AI pair programming)
if ! command -v aider &> /dev/null; then
    echo -e "${c}Installing aider-chat...${r}"
    pip3 install aider-chat --break-system-packages 2>/dev/null || pip3 install aider-chat
else
    echo -e "${c}aider-chat already installed.${r}"
fi
