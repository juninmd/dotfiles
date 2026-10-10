#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Insomnia...${r}"
wget -qO- https://insomnia.rest/keys/debian-public.key.asc | sudo tee /etc/apt/trusted.gpg.d/insomnia.asc
echo "deb [arch=amd64] https://insomnia.rest/debian/ stable main" | sudo tee /etc/apt/sources.list.d/insomnia.list
sudo apt update
sudo apt install -y insomnia
echo -e "${c}Insomnia installed!${r}"
