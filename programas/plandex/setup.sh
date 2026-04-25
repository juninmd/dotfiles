#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Plandex (AI coding engine)
if ! command -v plandex &> /dev/null; then
    echo -e "${c}Installing plandex...${r}"
    curl -sL https://plandex.ai/install.sh | bash
else
    echo -e "${c}plandex already installed.${r}"
fi
