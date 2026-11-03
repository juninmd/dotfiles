#!/usr/bin/env bash
set -euo pipefail
if command -v apt-get &>/dev/null; then
    sudo apt-add-repository ppa:fish-shell/release-3 -y || true
    sudo apt-get update
    sudo apt-get install -y fish
elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm fish
elif command -v dnf &>/dev/null; then
    sudo dnf install -y fish
elif command -v brew &>/dev/null; then
    brew install fish
else
    echo "Unsupported package manager for fish shell."
    exit 1
fi
