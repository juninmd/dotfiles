#!/bin/bash
c='\e[32m'
r='\e[0m'

echo -e "${c}Installing Yazi (File Manager)...${r}"

# Check for Cargo
if ! command -v cargo &> /dev/null; then
    echo -e "${c}Cargo not found. Please install Rust first (or select Option 2: Modern CLI Tools).${r}"
    exit 1
fi

# Source Helper Functions
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    echo -e "${c}Warning: cargo_helper.sh not found. Defining fallback function.${r}"
    install_cargo_crate() {
        local crate="$1"
        cargo install "$crate"
    }
fi

# Install Yazi
install_cargo_crate yazi-fm yazi
install_cargo_crate yazi-cli ya

echo -e "${c}Configuring Yazi...${r}"
CONFIG_DIR="$HOME/.config/yazi"
mkdir -p "$CONFIG_DIR"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
THEME_FILE="$SCRIPT_DIR/theme.toml"

if [ -f "$THEME_FILE" ]; then
    ln -sf "$THEME_FILE" "$CONFIG_DIR/theme.toml"
    echo -e "${c}Yazi theme linked.${r}"
else
    echo -e "${c}Warning: theme.toml not found in $SCRIPT_DIR${r}"
fi

echo -e "${c}Yazi setup complete!${r}"
