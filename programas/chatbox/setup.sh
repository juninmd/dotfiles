#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing Chatbox...${r}"
if ! command -v chatbox &> /dev/null; then
    # Usually AppImage or snap. Will use snap if available.
    sudo snap install chatbox
else
    echo -e "${c}chatbox already installed.${r}"
fi