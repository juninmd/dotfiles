#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Shell-GPT (AI in terminal)
if ! command -v sgpt &> /dev/null; then
    echo -e "${c}Installing shell-gpt...${r}"
    pip3 install shell-gpt --break-system-packages 2>/dev/null || pip3 install shell-gpt
else
    echo -e "${c}shell-gpt already installed.${r}"
fi
