#!/usr/bin/env bash
set -euo pipefail

if ! command -v cargo-binstall &> /dev/null; then
    printf "%b\n" "\e[32mInstalling cargo-binstall...\e[0m"
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | /usr/bin/env sh
else
    printf "%b\n" "\e[32mcargo-binstall is already installed.\e[0m"
fi
