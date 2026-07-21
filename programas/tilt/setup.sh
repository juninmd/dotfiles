#!/bin/bash
c='\e[32m'
r='\e[0m'
# Tilt (Microservices dev in K8s)
if ! command -v tilt &> /dev/null; then
    echo -e "${c}Installing tilt...${r}"
    curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | /usr/bin/env bash # NOSONAR
else
    echo -e "${c}tilt already installed.${r}"
fi
