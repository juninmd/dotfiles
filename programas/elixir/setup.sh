#!/usr/bin/env bash
set -euo pipefail
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing elixir (Modern programming language)...${r}"
sudo apt update
sudo apt install -y elixir erlang
