#!/usr/bin/env bash

# Installing restic
if ! command -v restic &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y restic
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y restic
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm restic
    else
        echo "Could not find apt-get, dnf, or pacman. Please install restic manually."
    fi
else
    echo "restic is already installed."
fi
