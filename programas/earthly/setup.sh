#!/bin/bash
c='\e[32m'
r='\e[0m'
# Earthly (Build automation)
if ! command -v earthly &> /dev/null; then
    printf "%b\n" "${c}Installing earthly...${r}"
    sudo wget -q https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly
    sudo chmod +x /usr/local/bin/earthly
else
    printf "%b\n" "${c}earthly already installed.${r}"
fi
