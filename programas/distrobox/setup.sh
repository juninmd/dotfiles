#!/usr/bin/env sh
set -eu

echo "Installing distrobox..."

if ! command -v distrobox > /dev/null 2>&1; then
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo /usr/bin/env sh
fi
