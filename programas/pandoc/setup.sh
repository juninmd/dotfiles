#!/usr/bin/env bash

# Installing pandoc
if ! command -v pandoc &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y pandoc
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y pandoc
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm pandoc
    else
        echo "Could not find apt-get, dnf, or pacman. Please install pandoc manually."
    fi
else
    echo "pandoc is already installed."
fi
