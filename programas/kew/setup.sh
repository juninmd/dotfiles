#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install -y libglib2.0-dev libopusfile-dev libavformat-dev make gcc build-essential

TMP_DIR=$(mktemp -d)
git clone https://github.com/a-rav/kew.git "$TMP_DIR"
cd "$TMP_DIR"
make
sudo make install
cd - > /dev/null
rm -rf "$TMP_DIR"
