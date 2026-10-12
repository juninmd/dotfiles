#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color
printf "%b\n" "${c}Installing Modern CLI Tools...${r}"
# Update apt first
sudo apt update

# Install dependencies for adding repos and essential build tools
sudo apt install -y wget gpg python3-pip golang-go curl unzip ffmpeg build-essential
# Check for Cargo (Rust)
if ! command -v cargo &> /dev/null; then
    printf "%b\n" "${c}Cargo not found. Installing Rust...${r}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /usr/bin/env sh -s -- -y
    source "$HOME/.cargo/env"
fi
# Source Helper Functions
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    printf "%b\n" "${c}Warning: cargo_helper.sh not found. Defining fallback function.${r}"
    install_cargo_crate() {
        local crate="$1"
        cargo install "$crate"
    }
    install_go_package() {
        local package="$1"
        go install "$package"
    }
fi
printf "%b\n" "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
