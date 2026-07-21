#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if ! command -v btop &> /dev/null; then
    echo -e "${c}Installing btop...${r}"
    if apt-cache show btop &> /dev/null; then # NOSONAR
        sudo apt install -y btop # NOSONAR
    else
        sudo snap install btop
    fi
else
    echo -e "${c}btop already installed.${r}"
fi

# Configure btop theme
if command -v btop &> /dev/null; then
    BTOP_THEMES_DIR="$HOME/.config/btop/themes"
    mkdir -p "$BTOP_THEMES_DIR"

    # Try to find the theme in cli-tools where it originally was
    BTOP_THEME_FILE="$ROOT_DIR/programas/cli-tools/themes/btop/synthwave.theme"

    if [ -f "$BTOP_THEME_FILE" ]; then
        cp "$BTOP_THEME_FILE" "$BTOP_THEMES_DIR/synthwave.theme"

        # Update btop.conf to use the theme if it exists, or creating a minimal one
        BTOP_CONF="$HOME/.config/btop/btop.conf"
        if [ ! -f "$BTOP_CONF" ]; then
            echo "color_theme = \"$BTOP_THEMES_DIR/synthwave.theme\"" > "$BTOP_CONF"
            echo "theme_background = False" >> "$BTOP_CONF"
            echo "truecolor = True" >> "$BTOP_CONF"
            echo "vim_keys = True" >> "$BTOP_CONF"
        else
            if grep -q "^color_theme =" "$BTOP_CONF"; then
                sed -i 's|^color_theme = .*|color_theme = \"'$BTOP_THEMES_DIR'/synthwave.theme\"|' "$BTOP_CONF"
            else
                echo "color_theme = \"$BTOP_THEMES_DIR/synthwave.theme\"" >> "$BTOP_CONF"
            fi
        fi
        echo -e "${c}Applied synthwave theme for btop.${r}"
    else
        echo -e "${c}Warning: synthwave.theme not found${r}"
    fi
fi
