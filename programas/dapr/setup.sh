#!/usr/bin/env bash
set -e
echo "Installing dapr CLI..."
if command -v dapr &> /dev/null; then
    echo "dapr is already installed."
else
    wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /usr/bin/env sh
    echo "dapr CLI installed successfully."
fi
