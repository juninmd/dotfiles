#!/bin/bash
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing podman...${r}"
if ! command -v podman &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install podman
else
    printf "%b\n" "${c}podman already installed.${r}"
fi