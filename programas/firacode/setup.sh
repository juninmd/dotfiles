#!/usr/bin/env bash
set -euo pipefail

printf "%b\n" "\e[32mInstalling FiraCode Nerd Font...\e[0m"
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi
if ls "$FONT_DIR"/FiraCode*.ttf 1> /dev/null 2>&1; then
    printf "%b\n" "\e[32mFiraCode Nerd Font seems to be installed.\e[0m"
else
    wget -qO /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -o -q /tmp/FiraCode.zip -d "$FONT_DIR"
    rm /tmp/FiraCode.zip
    printf "%b\n" "\e[32mFiraCode Nerd Font installed.\e[0m"
    if command -v fc-cache &> /dev/null; then
        printf "%b\n" "\e[32mUpdating font cache...\e[0m"
        fc-cache -fv
    fi
fi
