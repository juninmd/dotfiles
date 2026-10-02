#!/bin/bash
c='\e[32m'
r='\e[0m'
# turso (Edge database CLI)
if ! command -v turso &> /dev/null; then
    printf "%b\n" "${c}Installing turso...${r}"
    curl -sL https://get.turso.tech/install.sh | bash
else
    printf "%b\n" "${c}turso already installed.${r}"
fi
