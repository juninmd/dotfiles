#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing nix (Modern package manager)...${r}"
sudo apt update
curl -sL https://nixos.org/nix/install | /usr/bin/env sh -s -- --daemon --yes
