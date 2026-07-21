#!/bin/bash
c='\e[32m'
r='\e[0m'
# flyctl (Fly.io CLI)
if ! command -v flyctl &> /dev/null; then
    echo -e "${c}Installing flyctl...${r}"
    curl -L https://fly.io/install.sh | sh
else
    echo -e "${c}flyctl already installed.${r}"
fi
