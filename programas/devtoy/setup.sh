#!/usr/bin/env bash
set -e

# Install devtoys CLI (Swiss Army knife for developers)
TMP_DIR=$(mktemp -d)
echo "Downloading DevToys CLI for Linux..."
wget -qO "$TMP_DIR/devtoys_cli.zip" "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64.zip"

echo "Extracting and installing..."
unzip -q "$TMP_DIR/devtoys_cli.zip" -d "$TMP_DIR/devtoys"

# DevToys-cli provides a DevToys.CLI binary and accompanying files.
# We copy everything to ~/.local/lib/devtoys-cli and symlink the binary.
mkdir -p "$HOME/.local/lib/devtoys-cli"
cp -r "$TMP_DIR/devtoys/"* "$HOME/.local/lib/devtoys-cli/"

mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/lib/devtoys-cli/DevToys.CLI" "$HOME/.local/bin/devtoy"

rm -rf "$TMP_DIR"
echo "DevToys CLI installed successfully."
