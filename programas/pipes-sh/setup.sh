#!/usr/bin/env bash

echo "Installing pipes-sh..."
if ! command -v pipes.sh &> /dev/null; then
    sudo apt install -y pipes-sh
else
    echo "pipes-sh already installed."
fi
echo "pipes-sh installed successfully."
