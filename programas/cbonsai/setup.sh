#!/usr/bin/env bash

echo "Installing cbonsai..."
if ! command -v cbonsai &> /dev/null; then
    sudo apt install -y cbonsai
else
    echo "cbonsai already installed."
fi
echo "cbonsai installed successfully."
