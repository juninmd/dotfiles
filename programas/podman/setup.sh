#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing podman...${r}"
if ! command -v podman &> /dev/null; then
    sudo apt-get update # NOSONAR
    sudo apt-get -y install podman # NOSONAR
else
    echo -e "${c}podman already installed.${r}"
fi