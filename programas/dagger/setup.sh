#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Dagger (Programmable CI/CD engine)
if ! command -v dagger &> /dev/null; then
    printf "%b\n" "${c}Installing dagger...${r}"
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo sh
else
    printf "%b\n" "${c}dagger already installed.${r}"
fi