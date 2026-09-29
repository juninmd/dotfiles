#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Fastfetch (Modern System Info)
if ! command -v fastfetch &> /dev/null; then
    printf "%b\n" "${c}Installing fastfetch...${r}"
    sudo add-apt-repository ppa:zhanghua/fastfetch -y
    sudo apt update
    sudo apt install -y fastfetch
else
    printf "%b\n" "${c}fastfetch already installed.${r}"
fi

# Configure Fastfetch
printf "%b\n" "${c}Configuring Fastfetch...${r}"
FASTFETCH_CONFIG_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_CONFIG_DIR"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
FASTFETCH_CONFIG_FILE="$SCRIPT_DIR/configs/fastfetch.jsonc"

if [ -f "$FASTFETCH_CONFIG_FILE" ]; then
    ln -sf "$FASTFETCH_CONFIG_FILE" "$FASTFETCH_CONFIG_DIR/config.jsonc"
    printf "%b\n" "${c}Fastfetch config linked.${r}"
else
    printf "%b\n" "${c}Warning: fastfetch.jsonc not found in $SCRIPT_DIR/configs${r}"
fi
