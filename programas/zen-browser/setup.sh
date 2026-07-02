#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing Zen Browser...${r}"

# Setup directories
APP_DIR="$HOME/Applications"
mkdir -p "$APP_DIR"
ZEN_BIN="$APP_DIR/ZenBrowser.AppImage"

echo -e "${c}Downloading Zen Browser AppImage...${r}"
# Download the latest generic appimage from GitHub
curl -L -o "$ZEN_BIN" "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage"
chmod +x "$ZEN_BIN"

echo -e "${c}Creating Desktop Entry...${r}"
mkdir -p "$HOME/.local/share/applications"
DESKTOP_FILE="$HOME/.local/share/applications/zen-browser.desktop"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Zen Browser
Exec=$ZEN_BIN
Icon=web-browser
Type=Application
Categories=Network;WebBrowser;
Terminal=false
StartupNotify=true
EOF

echo -e "${c}Zen Browser installed successfully!${r}"
