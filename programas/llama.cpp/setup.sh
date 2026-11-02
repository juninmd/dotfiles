#!/usr/bin/env bash
set -euo pipefail
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/ggerganov/llama.cpp "$TMP_DIR/llama.cpp"
cd "$TMP_DIR/llama.cpp"
make -j
if command -v sudo &> /dev/null; then
    sudo cp llama-cli /usr/local/bin/ || cp llama-cli "$HOME/.local/bin/"
else
    mkdir -p "$HOME/.local/bin/"
    cp llama-cli "$HOME/.local/bin/"
fi
cd - > /dev/null
rm -rf "$TMP_DIR"
