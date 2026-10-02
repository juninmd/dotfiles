#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if [ ! -d "$HOME/.config/nvim" ]; then
    printf "%b\n" "${c}Installing LazyVim starter...${r}"
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
else
    printf "%b\n" "${c}Neovim configuration already exists at ~/.config/nvim.${r}"
fi
