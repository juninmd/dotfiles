#!/usr/bin/env bash
set -e
echo "Installing ntfy..."
if command -v ntfy &> /dev/null; then
    echo "ntfy is already installed."
else
    # Fetch the latest release asset for ntfy dynamically since version is in the filename
    LATEST_URL=$(curl -s https://api.github.com/repos/binwiederhier/ntfy/releases/latest | grep "browser_download_url" | grep "linux_amd64.tar.gz" | cut -d '"' -f 4 | head -n 1)
    curl -sL "$LATEST_URL" | tar -xz -C /tmp
    # The extracted dir has the version name, let's find it
    EXTRACTED_DIR=$(find /tmp -maxdepth 1 -type d -name "ntfy_*_linux_amd64" | head -n 1)
    if [ -n "$EXTRACTED_DIR" ]; then
        sudo cp "$EXTRACTED_DIR/ntfy" /usr/local/bin/
        sudo chmod +x /usr/local/bin/ntfy
        rm -rf "$EXTRACTED_DIR"
        echo "ntfy installed successfully."
    else
        echo "Error: Could not find extracted ntfy directory."
    fi
fi
