#!/usr/bin/env bash
set -e
echo "Installing terrascan..."
if command -v terrascan &> /dev/null; then
    echo "terrascan already installed."
else
    # Fetch the latest release asset dynamically
    LATEST_URL=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")
    curl -L "$LATEST_URL" > terrascan.tar.gz
    tar -xf terrascan.tar.gz terrascan || true
    sudo install terrascan /usr/local/bin/
    rm -f terrascan terrascan.tar.gz
    echo "terrascan installed."
fi
