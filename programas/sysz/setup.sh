#!/bin/bash
c='\e[32m'
r='\e[0m'
# sysz (fzf terminal UI for systemctl)
if ! command -v sysz &> /dev/null; then
    printf "%b\n" "${c}Installing sysz...${r}"
    curl -sL https://raw.githubusercontent.com/joehillen/sysz/master/sysz | sudo tee /usr/local/bin/sysz >/dev/null
    sudo chmod +x /usr/local/bin/sysz
else
    printf "%b\n" "${c}sysz already installed.${r}"
fi
