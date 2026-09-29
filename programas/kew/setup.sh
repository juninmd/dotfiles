#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Instalando kew..."
if ! command -v kew &> /dev/null; then
    TMP_DIR=$(mktemp -d)
    git clone https://github.com/ravachol/kew.git "$TMP_DIR/kew"
    cd "$TMP_DIR/kew"
    # kew dependencies include libglib2.0-dev, libopusfile-dev, libavformat-dev
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y libglib2.0-dev libopusfile-dev libavformat-dev gcc make
    fi
    make
    sudo make install
    rm -rf "$TMP_DIR"
else
    echo "kew já está instalado."
fi
