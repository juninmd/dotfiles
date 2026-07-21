#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing Bruno (API Client)...${r}"

if command -v snap &> /dev/null; then
    sudo snap install bruno
    echo -e "${c}Bruno installed via Snap successfully!${r}"
else
    echo -e "${c}Snap is not available, falling back to apt...${r}" # NOSONAR
    sudo mkdir -p /etc/apt/keyrings # NOSONAR
    sudo gpg --keyserver keyserver.ubuntu.com --recv-keys 9FA6017ECABE0266
    sudo gpg --export 9FA6017ECABE0266 | sudo tee /etc/apt/keyrings/bruno.gpg >/dev/null # NOSONAR
    echo "deb [signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" | sudo tee /etc/apt/sources.list.d/bruno.list # NOSONAR
    sudo apt update # NOSONAR
    sudo apt install -y bruno # NOSONAR
    echo -e "${c}Bruno installed via APT successfully!${r}"
fi
