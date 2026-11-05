#!/usr/bin/env bash

# Installing magic-wormhole
if ! command -v magic-wormhole &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y magic-wormhole
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y magic-wormhole
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm magic-wormhole
    else
        echo "Could not find apt-get, dnf, or pacman. Please install magic-wormhole manually."
    fi
else
    echo "magic-wormhole is already installed."
fi
