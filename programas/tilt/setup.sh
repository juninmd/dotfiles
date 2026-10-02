#!/bin/bash
c='\e[32m'
r='\e[0m'
# Tilt (Microservices dev in K8s)
if ! command -v tilt &> /dev/null; then
    printf "%b\n" "${c}Installing tilt...${r}"
    curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | /usr/bin/env bash
else
    printf "%b\n" "${c}tilt already installed.${r}"
fi
