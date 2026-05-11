#!/usr/bin/env bash

c="\033[1;36m"
r="\033[0m"

echo -e "${c}Installing dagger...${r}"
if ! command -v dagger &> /dev/null; then
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo sh
    echo -e "${c}dagger installed successfully.${r}"
else
    echo -e "${c}dagger already installed.${r}"
fi
