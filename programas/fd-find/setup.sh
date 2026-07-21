#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    echo -e "${c}Installing fd-find...${r}"
    sudo apt install -y fd-find # NOSONAR

    # Create symlink if needed
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -s $(which fdfind) ~/.local/bin/fd
    fi
else
    echo -e "${c}fd-find already installed.${r}"
fi
