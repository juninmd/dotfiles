#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v tmux &> /dev/null; then
    printf "%b\n" "${c}Installing tmux...${r}"
    sudo apt update
    sudo apt install -y tmux
else
    printf "%b\n" "${c}tmux is already installed.${r}"
fi
