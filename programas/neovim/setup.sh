#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Neovim...${r}"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
rm nvim-linux64.tar.gz
echo -e "${c}Neovim installed!${r}"
