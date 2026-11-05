#!/usr/bin/env bash

# Installing syncthing
if ! command -v syncthing &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y syncthing
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y syncthing
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm syncthing
    else
        echo "Could not find apt-get, dnf, or pacman. Please install syncthing manually."
    fi
else
    echo "syncthing is already installed."
fi
