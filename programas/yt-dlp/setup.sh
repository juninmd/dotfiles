#!/bin/bash
c='\e[32m'
r='\e[0m'

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    # Fallback
    install_cargo_crate() { cargo install "$1"; }
    install_go_package() { go install "$1"; }
fi

if command -v pipx &> /dev/null; then
    pipx install yt-dlp
elif command -v uv &> /dev/null; then
    uv tool install yt-dlp
else
    python3 -m pip install yt-dlp --break-system-packages 2>/dev/null || python3 -m pip install yt-dlp # NOSONAR
fi
