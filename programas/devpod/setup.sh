#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing devpod...${r}"
if ! command -v devpod &> /dev/null; then
    curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" # NOSONAR
    sudo install -c -m 0755 devpod /usr/local/bin
    rm devpod
else
    echo -e "${c}devpod already installed.${r}"
fi