#!/usr/bin/env bash
set -e

c="\e[36m"
r="\e[0m"

if ! command -v dagger &> /dev/null; then
    echo -e "${c}Installing dagger...${r}"
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo sh
    echo -e "${c}dagger setup complete.${r}"
else
    echo -e "${c}dagger already installed.${r}"
fi
