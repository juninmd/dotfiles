#!/usr/bin/env bash
set -euo pipefail

install_go_package() {
    local package="$1"
    if ! command -v go &> /dev/null; then
        echo "Go is not installed. Installing Go..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y golang-go
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y golang
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm go
        else
            echo "Error: Cannot find package manager to install Go."
            return 1
        fi
    fi
    go install "$package"
}
