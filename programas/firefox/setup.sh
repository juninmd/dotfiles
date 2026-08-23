#!/usr/bin/env bash
set -e

echo "Installing Firefox via apt..."
sudo apt-get update
sudo apt-get install -y firefox
echo "Firefox installed successfully."
