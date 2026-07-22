#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing nix (Modern package manager)...${r}"
sudo apt update
curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
