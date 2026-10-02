#!/bin/bash
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing devpod...${r}"
if ! command -v devpod &> /dev/null; then
    curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
    sudo install -c -m 0755 devpod /usr/local/bin
    rm devpod
else
    printf "%b\n" "${c}devpod already installed.${r}"
fi