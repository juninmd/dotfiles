#!/bin/bash
c='\e[32m'
r='\e[0m'
# Atlas (Database migrations)
if ! command -v atlas &> /dev/null; then
    echo -e "${c}Installing atlas...${r}"
    curl -sSf https://atlasgo.sh | /usr/bin/env bash # NOSONAR
else
    echo -e "${c}atlas already installed.${r}"
fi
