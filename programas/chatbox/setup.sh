#!/bin/bash
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing Chatbox...${r}"
if ! command -v chatbox &> /dev/null; then
    # Usually AppImage or snap. Will use snap if available.
    sudo snap install chatbox
else
    printf "%b\n" "${c}chatbox already installed.${r}"
fi