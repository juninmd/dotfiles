#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Shell-GPT (AI in terminal)
if ! command -v sgpt &> /dev/null; then
    printf "%b\n" "${c}Installing shell-gpt...${r}"
    pip3 install shell-gpt --break-system-packages 2>/dev/null || pip3 install shell-gpt
else
    printf "%b\n" "${c}shell-gpt already installed.${r}"
fi
