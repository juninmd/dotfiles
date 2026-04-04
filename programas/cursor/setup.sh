#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Cursor (AI Code Editor)...${r}"
mkdir -p "$HOME/Applications"
curl -L -o "$HOME/Applications/cursor.AppImage" "https://downloader.cursor.sh/linux/appImage/x64"
chmod +x "$HOME/Applications/cursor.AppImage"

mkdir -p "$HOME/.local/share/applications"
cat <<EOF > "$HOME/.local/share/applications/cursor.desktop"
[Desktop Entry]
Name=Cursor
Exec=$HOME/Applications/cursor.AppImage
Icon=cursor
Type=Application
Categories=Development;TextEditor;
EOF

echo -e "${c}Cursor installed to $HOME/Applications/cursor.AppImage${r}"
