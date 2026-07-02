#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing LM Studio...${r}"

# Setup directories
APP_DIR="$HOME/Applications"
mkdir -p "$APP_DIR"
LM_BIN="$APP_DIR/LM-Studio.AppImage"

echo -e "${c}Downloading LM Studio AppImage...${r}"
# Download LM Studio AppImage (LM Studio Linux releases use this direct link)
curl -L -o "$LM_BIN" "https://installers.lmstudio.ai/linux/x64/appimage"
chmod +x "$LM_BIN"

echo -e "${c}Creating Desktop Entry...${r}"
mkdir -p "$HOME/.local/share/applications"
DESKTOP_FILE="$HOME/.local/share/applications/lm-studio.desktop"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=LM Studio
Exec=$LM_BIN
Icon=utilities-terminal
Type=Application
Categories=Development;
Terminal=false
StartupNotify=true
EOF

echo -e "${c}LM Studio installed successfully!${r}"
