#!/usr/bin/env bash
set -euo pipefail

echo "Installing kew dependencies and compiling from source..."
sudo apt-get update
sudo apt-get install -y libglib2.0-dev libopusfile-dev libavformat-dev make gcc build-essential

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://github.com/ravachol/kew.git
cd kew
make
sudo make install
cd -
rm -rf "$TEMP_DIR"
