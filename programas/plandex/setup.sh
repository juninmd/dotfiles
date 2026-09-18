#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Plandex (AI coding engine)
if ! command -v plandex &> /dev/null; then
    printf "%b\n" "${c}Installing plandex...${r}"
    curl -sL https://plandex.ai/install.sh | bash
else
    printf "%b\n" "${c}plandex already installed.${r}"
fi
