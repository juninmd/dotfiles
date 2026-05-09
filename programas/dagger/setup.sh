#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v dagger &> /dev/null; then
    echo -e "${c}Installing dagger...${r}"
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo sh
else
    echo -e "${c}dagger already installed.${r}"
fi
