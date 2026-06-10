#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing podman...${r}"
if ! command -v podman &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install podman
else
    echo -e "${c}podman already installed.${r}"
fi