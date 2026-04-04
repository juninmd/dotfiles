#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Warp Terminal...${r}"
sudo apt-get install -y wget gpg
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | sudo gpg --yes --dearmor -o /etc/apt/keyrings/warpdotdev.gpg
sudo chmod 644 /etc/apt/keyrings/warpdotdev.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" | sudo tee /etc/apt/sources.list.d/warpdotdev.list
sudo apt-get update
sudo apt-get install -y warp-terminal
echo -e "${c}Warp Terminal installed successfully!${r}"
