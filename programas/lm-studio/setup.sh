#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$HOME/Applications"
mkdir -p "$APP_DIR"

# Download the latest LM Studio AppImage
wget -O "$APP_DIR/LM-Studio.AppImage" "https://releases.lmstudio.ai/linux/x86/latest/LM-Studio-Linux-x86_64.AppImage"
chmod +x "$APP_DIR/LM-Studio.AppImage"

# Create a desktop entry
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

cat << 'DESKTOP' > "$DESKTOP_DIR/lm-studio.desktop"
[Desktop Entry]
Name=LM Studio
Exec=env APPIMAGE_EXTRACT_AND_RUN=1 "$HOME/Applications/LM-Studio.AppImage"
Terminal=false
Type=Application
Icon=utilities-terminal
Categories=Development;
DESKTOP
