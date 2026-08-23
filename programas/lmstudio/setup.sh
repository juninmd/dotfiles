#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing LM Studio...${r}"

# Setup directories
APP_DIR="$HOME/Applications"
mkdir -p "$APP_DIR"
LM_BIN="$APP_DIR/LM-Studio.AppImage"

echo -e "${c}Downloading LM Studio AppImage...${r}"
curl -L -o "$LM_BIN" "https://installers.lmstudio.ai/linux/x64/appimage"
chmod +x "$LM_BIN"

echo -e "${c}Creating Desktop Entry...${r}"
mkdir -p "$HOME/.local/share/applications"
DESKTOP_FILE="$HOME/.local/share/applications/lm-studio.desktop"

cat <<DESKTOPEOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=LM Studio
Exec=$LM_BIN
Icon=utilities-terminal
Type=Application
Categories=Development;
Terminal=false
StartupNotify=true
DESKTOPEOF

echo -e "${c}LM Studio installed successfully!${r}"
