#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v oh-my-posh &> /dev/null; then
    printf "%b\n" "${c}Installing oh-my-posh...${r}"
    mkdir -p ~/.local/bin
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
else
    printf "%b\n" "${c}oh-my-posh is already installed.${r}"
fi
