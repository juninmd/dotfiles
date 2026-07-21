#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Warp Terminal...${r}"
sudo apt-get install -y wget gpg # NOSONAR
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | sudo gpg --yes --dearmor -o /etc/apt/keyrings/warpdotdev.gpg # NOSONAR
sudo chmod 644 /etc/apt/keyrings/warpdotdev.gpg # NOSONAR
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" | sudo tee /etc/apt/sources.list.d/warpdotdev.list # NOSONAR
sudo apt-get update # NOSONAR
sudo apt-get install -y warp-terminal # NOSONAR
echo -e "${c}Warp Terminal installed successfully!${r}"
