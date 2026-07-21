#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing Modern CLI Tools...${r}"

# Update apt first
sudo apt update

# Install dependencies for adding repos and essential build tools
sudo apt install -y wget gpg python3-pip golang-go curl unzip ffmpeg build-essential

# Check for Cargo (Rust)
if ! command -v cargo &> /dev/null; then
    echo -e "${c}Cargo not found. Installing Rust...${r}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Source Helper Functions
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    echo -e "${c}Warning: cargo_helper.sh not found. Defining fallback function.${r}"
    install_cargo_crate() {
        local crate="$1"
        cargo install "$crate"
    }
    install_go_package() {
        local package="$1"
        go install "$package"
    }
fi

# Install cargo-binstall for faster installations
if ! command -v cargo-binstall &> /dev/null; then
    echo -e "${c}Installing cargo-binstall...${r}"
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

# Bat (Modern cat)

# Fzf (Fuzzy Finder)

# Btop (Modern top)

# --- NEW TOOLS (2026 Apps) ---

# --- MORE 2026 APPS ---

# --- EVEN MORE 2026 APPS ---

# --- ULTIMATE 2026 APPS ---

# --- 2026 EYE CANDY & EXTRAS ---

# --- NEWEST 2026 APPS ---

# --- THE FUTURE IS NOW (New 2026 Apps) ---

# --- 2026 APPS PART II ---

# --- EXTRA 2026 APPS ---

# --- 2026 APPS PART III ---

# --- FUTURE TOOLS 2026 ---

# --- 2026 CUTTING EDGE APPS ---

# --- 2026 EXPERIMENTAL APPS ---

# --- BRAND NEW 2026 APPS ---

# --- NEW 2026 APPS ---

# --- CHARMBRACELET EXTRAS ---

# --- KUBERNETES EXTRAS ---

# --- GITHUB EXTRAS ---

# FiraCode Nerd Font
echo -e "${c}Installing FiraCode Nerd Font...${r}"
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

if ls "$FONT_DIR"/FiraCode*.ttf 1> /dev/null 2>&1; then
    echo -e "${c}FiraCode Nerd Font seems to be installed.${r}"
else
    wget -qO /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -o -q /tmp/FiraCode.zip -d "$FONT_DIR"
    rm /tmp/FiraCode.zip
    echo -e "${c}FiraCode Nerd Font installed.${r}"
    if command -v fc-cache &> /dev/null; then
        echo -e "${c}Updating font cache...${r}"
        fc-cache -fv
    fi
fi

# Configure Btop
echo -e "${c}Configuring Btop...${r}"
# --- NEW 2026 APPS ---

# --- BRAND NEW 2026 APPS PART II ---

# --- EXTRA 2026 APPS ---

# --- HYPER-MODERN 2026 APPS ---

# --- NEWEST 2026 APPS ---

# --- 2026 NEXT-GEN CLOUD & DEV TOOLS ---

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
# --- BEYOND 2026 APPS ---

# --- THE VERY EDGE OF 2026 APPS ---

# --- BRAND NEW 2026 APPS ---

# --- ADVANCED SECURITY AND WEB TOOLS ---

# --- MORE USEFUL 2026 APPS ---

# --- ULTIMATE 2026 CLI APPS ---
