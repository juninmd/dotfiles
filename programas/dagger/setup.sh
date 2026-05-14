#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Dagger (Programmable CI/CD engine)
if ! command -v dagger &> /dev/null; then
    echo -e "${c}Installing dagger...${r}"
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo sh
else
    echo -e "${c}dagger already installed.${r}"
fi