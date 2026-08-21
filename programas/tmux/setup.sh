#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v tmux &> /dev/null; then
    echo -e "${c}Installing tmux...${r}"
    sudo apt update
    sudo apt install -y tmux
else
    echo -e "${c}tmux is already installed.${r}"
fi
