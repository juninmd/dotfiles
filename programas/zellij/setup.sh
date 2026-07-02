#!/bin/bash
c='\e[32m'
r='\e[0m'

echo -e "${c}Installing Zellij...${r}"

# Check for Cargo
if ! command -v cargo &> /dev/null; then
    echo -e "${c}Cargo not found. Please install Rust first (or select Option 2: Modern CLI Tools).${r}"
    exit 1
fi

if ! command -v zellij &> /dev/null; then
    cargo install --locked zellij
else
    echo -e "${c}Zellij already installed.${r}"
fi

echo -e "${c}Configuring Zellij...${r}"
CONFIG_DIR="$HOME/.config/zellij"
mkdir -p "$CONFIG_DIR"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/config.kdl"

if [ -f "$CONFIG_FILE" ]; then
    ln -sf "$CONFIG_FILE" "$CONFIG_DIR/config.kdl"
    echo -e "${c}Zellij config linked.${r}"
else
    echo -e "${c}Warning: config.kdl not found in $SCRIPT_DIR${r}"
fi

echo -e "${c}Zellij setup complete!${r}"
