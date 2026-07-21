#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v eza &> /dev/null; then
    echo -e "${c}Installing eza...${r}"
    sudo mkdir -p /etc/apt/keyrings # NOSONAR
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg # NOSONAR
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list # NOSONAR
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list # NOSONAR
    sudo apt update # NOSONAR
    sudo apt install -y eza # NOSONAR
else
    echo -e "${c}eza already installed.${r}"
fi
