#!/bin/bash
c="\e[32m"
r="\e[0m"
printf "%b\n" "${c}Installing daytona...${r}"
if ! command -v daytona &> /dev/null; then
    (curl -sfL https://download.daytona.io/daytona/install.sh | sudo bash)
else
    printf "%b\n" "${c}daytona already installed.${r}"
fi