#!/usr/bin/env bash

set -e

c='\e[32m' # Green Color
r='\e[0m'  # Reset Color

echo -e "${c}Installing LM Studio...${r}"

APP_DIR="$HOME/Applications"
mkdir -p "$APP_DIR"

# Download LM Studio AppImage
APPIMAGE_URL="https://releases.lmstudio.ai/linux/x86/standard/latest/LM_Studio_Linux.AppImage"
DEST_FILE="$APP_DIR/LM_Studio.AppImage"

echo -e "${c}Downloading LM Studio AppImage...${r}"
wget -q -O "$DEST_FILE" "$APPIMAGE_URL"
chmod +x "$DEST_FILE"

# Create Desktop Entry
echo -e "${c}Creating desktop entry...${r}"
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"
DESKTOP_FILE="$DESKTOP_DIR/lm-studio.desktop"

cat <<DESKTOP > "$DESKTOP_FILE"
[Desktop Entry]
Name=LM Studio
Comment=Discover, download, and run local LLMs
Exec=$DEST_FILE
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Development;
DESKTOP

chmod +x "$DESKTOP_FILE"

echo -e "${c}LM Studio installed successfully!${r}"
