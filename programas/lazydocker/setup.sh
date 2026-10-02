#!/bin/bash
c='\e[32m'
r='tput sgr0'

printf "%b\n" "${c}Installing LazyDocker...${r}"

# Get latest release tag (e.g., v0.20.0)
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

if [ -z "$LAZYDOCKER_VERSION" ]; then
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "Downloading LazyDocker v${LAZYDOCKER_VERSION}..."
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm lazydocker lazydocker.tar.gz

printf "%b\n" "${c}Configuring LazyDocker...${r}"
CONFIG_DIR="$HOME/.config/lazydocker"
mkdir -p "$CONFIG_DIR"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/config.yml"

if [ -f "$CONFIG_FILE" ]; then
    ln -sf "$CONFIG_FILE" "$CONFIG_DIR/config.yml"
    printf "%b\n" "${c}LazyDocker config linked.${r}"
else
    printf "%b\n" "${c}Warning: config.yml not found in $SCRIPT_DIR${r}"
fi

printf "%b\n" "${c}LazyDocker installed and configured!${r}"
