#!/bin/bash
c='\e[32m'
r='tput sgr0'

echo -e "${c}Installing Starship Prompt...${r}"
# Install starship to /usr/local/bin by default (requires sudo usually, but the script handles it or asks)
# Using -y to accept defaults
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo -e "${c}Configuring Starship...${r}"
mkdir -p ~/.config
cp "$(dirname "$0")/starship.toml" ~/.config/starship.toml

echo -e "${c}Starship installed and configured!${r}"
echo -e "${c}Make sure to add 'eval \"\$(starship init zsh)\"' to your .zshrc${r}"
