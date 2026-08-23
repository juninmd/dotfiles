#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    echo -e "${c}Installing bat...${r}"
    sudo apt install -y bat

    # Create symlink if batcat exists but bat doesn't
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -s $(which batcat) ~/.local/bin/bat
    fi
else
    echo -e "${c}bat already installed.${r}"
fi

# Also migrate bat theme logic
if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
    BAT_CMD="bat"
    if ! command -v bat &> /dev/null; then
        BAT_CMD="batcat"
    fi
    BAT_CONFIG_DIR="$($BAT_CMD --config-dir)"
    mkdir -p "$BAT_CONFIG_DIR/themes"

    # The theme was originally in cli-tools/themes/bat, let's look for it there
    BAT_THEME_FILE="$ROOT_DIR/programas/cli-tools/themes/bat/synthwave.tmTheme"

    if [ -f "$BAT_THEME_FILE" ]; then
        cp "$BAT_THEME_FILE" "$BAT_CONFIG_DIR/themes/"
        $BAT_CMD cache --build
        echo -e "${c}Applied synthwave theme for bat.${r}"
    else
        echo -e "${c}Warning: synthwave.tmTheme not found${r}"
    fi
fi
