#!/bin/bash
c='\e[32m'
r='\e[0m'

printf "%b\n" "${c}Installing Zellij...${r}"

# Check for Cargo
if ! command -v cargo &> /dev/null; then
    printf "%b\n" "${c}Cargo not found. Please install Rust first (or select Option 2: Modern CLI Tools).${r}"
    exit 1
fi

if ! command -v zellij &> /dev/null; then
    cargo install --locked zellij
else
    printf "%b\n" "${c}Zellij already installed.${r}"
fi

printf "%b\n" "${c}Configuring Zellij...${r}"
CONFIG_DIR="$HOME/.config/zellij"
mkdir -p "$CONFIG_DIR"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/config.kdl"

if [ -f "$CONFIG_FILE" ]; then
    ln -sf "$CONFIG_FILE" "$CONFIG_DIR/config.kdl"
    printf "%b\n" "${c}Zellij config linked.${r}"
else
    printf "%b\n" "${c}Warning: config.kdl not found in $SCRIPT_DIR${r}"
fi

printf "%b\n" "${c}Zellij setup complete!${r}"
