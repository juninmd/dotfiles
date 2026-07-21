#!/bin/bash
c='\e[32m'
r='\e[0m'
# turso (Edge database CLI)
if ! command -v turso &> /dev/null; then
    echo -e "${c}Installing turso...${r}"
    curl -sL https://get.turso.tech/install.sh | bash # NOSONAR
else
    echo -e "${c}turso already installed.${r}"
fi
