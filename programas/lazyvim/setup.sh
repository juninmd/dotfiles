#!/bin/bash
c='\e[32m'
r='\e[0m'
if [ ! -d "$HOME/.config/nvim" ]; then
    echo -e "${c}Installing LazyVim starter...${r}"
    git clone --quiet https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
else
    echo -e "${c}Neovim configuration already exists at ~/.config/nvim.${r}"
fi
