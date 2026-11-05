#!/usr/bin/env bash

# Installing rclone
if ! command -v rclone &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y rclone
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y rclone
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm rclone
    else
        echo "Could not find apt-get, dnf, or pacman. Please install rclone manually."
    fi
else
    echo "rclone is already installed."
fi
