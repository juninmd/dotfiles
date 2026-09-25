#!/usr/bin/env bash
set -e

# The command-line music player kew is a C application that is compiled from source via make
# and requires dependencies including libglib2.0-dev, libopusfile-dev, and libavformat-dev

echo "Installing kew..."

# Install dependencies if apt is available
if command -v apt-get &> /dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y build-essential libglib2.0-dev libopusfile-dev libavformat-dev pkg-config
fi

# We can clone and build kew
KEW_DIR=$(mktemp -d)
git clone https://github.com/ravachol/kew.git "$KEW_DIR"
cd "$KEW_DIR"
make
sudo make install
cd -
rm -rf "$KEW_DIR"

echo "kew installed successfully."
