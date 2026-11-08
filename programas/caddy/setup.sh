#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../common/go_helper.sh"
if command -v apt-get &> /dev/null; then
    sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg --yes
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
    sudo apt-get update
    sudo apt-get install -y caddy
elif command -v dnf &> /dev/null; then
    sudo dnf install -y 'dnf-command(copr)'
    sudo dnf copr enable @caddy/caddy -y
    sudo dnf install -y caddy
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm caddy
else
    install_go_package "github.com/caddyserver/caddy/v2/cmd/caddy@latest"
fi
