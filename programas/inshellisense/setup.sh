#!/bin/bash
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing inshellisense...${r}"
if ! command -v inshellisense &> /dev/null; then
    if command -v npm &> /dev/null; then
        sudo npm install -g @microsoft/inshellisense
    else
        printf "%b\n" "${c}npm not found. Please install node first.${r}"
    fi
else
    printf "%b\n" "${c}inshellisense already installed.${r}"
fi