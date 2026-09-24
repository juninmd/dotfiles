#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[kew setup] $*"
}

log "Installing dependencies for kew..."
sudo apt-get update
sudo apt-get install -y build-essential libglib2.0-dev libopusfile-dev libavformat-dev git

log "Cloning and building kew..."
tmp_dir=$(mktemp -d)
git clone https://github.com/ravachol/kew.git "$tmp_dir/kew"
cd "$tmp_dir/kew"
make
sudo make install
rm -rf "$tmp_dir"
log "kew installation complete."
