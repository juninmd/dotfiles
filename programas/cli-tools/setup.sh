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

# Eza (Modern ls)
if ! command -v eza &> /dev/null; then
    echo -e "${c}Installing eza...${r}"
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
else
    echo -e "${c}eza already installed.${r}"
fi

# Bat (Modern cat)
echo -e "${c}Installing bat...${r}"
sudo apt install -y bat
mkdir -p ~/.local/bin
# Create symlink if batcat exists but bat doesn't
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    ln -s $(which batcat) ~/.local/bin/bat
fi

# Zoxide (Smarter cd)
if ! command -v zoxide &> /dev/null; then
    echo -e "${c}Installing zoxide...${r}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
    echo -e "${c}zoxide already installed.${r}"
fi

# Fzf (Fuzzy Finder)
echo -e "${c}Installing fzf...${r}"
sudo apt install -y fzf

# Ripgrep (Faster grep)
echo -e "${c}Installing ripgrep...${r}"
sudo apt install -y ripgrep

# Fd (Faster find)
echo -e "${c}Installing fd-find...${r}"
sudo apt install -y fd-find
# Create symlink if fdfind exists but fd doesn't
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    ln -s $(which fdfind) ~/.local/bin/fd
fi

# Btop (Modern top)
echo -e "${c}Installing btop...${r}"
# Check if btop is available in apt (newer Ubuntu), otherwise snap or manual
if apt-cache show btop &> /dev/null; then
    sudo apt install -y btop
else
    sudo snap install btop
fi

# Tealdeer (Fast tldr in Rust)
install_cargo_crate tealdeer tldr
if command -v tldr &> /dev/null; then
    tldr --update &> /dev/null &
fi

# --- NEW TOOLS (2026 Apps) ---

# Uv (Extremely fast Python package manager)
if ! command -v uv &> /dev/null; then
    echo -e "${c}Installing uv...${r}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo -e "${c}uv already installed.${r}"
fi

# Gping (Ping with a graph)
install_cargo_crate gping

# Jq (JSON Processor)
if ! command -v jq &> /dev/null; then
    echo -e "${c}Installing jq...${r}"
    sudo apt install -y jq
else
    echo -e "${c}jq already installed.${r}"
fi

# Yq (YAML Processor)
if ! command -v yq &> /dev/null; then
    echo -e "${c}Installing yq...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mikefarah/yq/v4@latest
    else
        echo -e "${c}Go not found. Using curl fallback for yq...${r}"
        # Fallback to binary download if go is missing (unlikely as it is installed above)
        sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        sudo chmod +x /usr/local/bin/yq
    fi
else
    echo -e "${c}yq already installed.${r}"
fi

# Xh (Friendly HTTP Client)
install_cargo_crate xh

# Gum (Shell UI)
if ! command -v gum &> /dev/null; then
    echo -e "${c}Installing gum...${r}"
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/gum@latest
    else
        echo -e "${c}Go not found, skipping gum installation.${r}"
    fi
else
    echo -e "${c}gum already installed.${r}"
fi

# Mods (AI on the command line)
if ! command -v mods &> /dev/null; then
    echo -e "${c}Installing mods...${r}"
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/mods@latest
    else
        echo -e "${c}Go not found, skipping mods installation.${r}"
    fi
else
    echo -e "${c}mods already installed.${r}"
fi

# Dust (Disk Usage)
install_cargo_crate du-dust dust

# Duf (Disk Usage/Free)
if ! command -v duf &> /dev/null; then
    echo -e "${c}Installing duf...${r}"
    if command -v go &> /dev/null; then
        go install github.com/muesli/duf@latest
    else
        echo -e "${c}Go not found, skipping duf installation via go install.${r}"
    fi
else
    echo -e "${c}duf already installed.${r}"
fi

# Delta (Git Diff)
install_cargo_crate git-delta delta

# Navi (Interactive Cheatsheet)
install_cargo_crate navi

# Atuin (Magical Shell History)
install_cargo_crate atuin

# Procs (Modern ps)
install_cargo_crate procs

# Hyperfine (Benchmarking)
install_cargo_crate hyperfine

# The Fuck (Command Corrector)
if ! command -v thefuck &> /dev/null; then
    echo -e "${c}Installing thefuck...${r}"
    pip3 install thefuck --break-system-packages 2>/dev/null || pip3 install thefuck
else
    echo -e "${c}thefuck already installed.${r}"
fi

# Mise (Polyglot Tool Version Manager)
if ! command -v mise &> /dev/null; then
    echo -e "${c}Installing mise...${r}"
    curl https://mise.jdx.dev/install.sh | sh
else
    echo -e "${c}mise already installed.${r}"
fi

# Doggo (Modern DNS Client)
if ! command -v doggo &> /dev/null; then
    echo -e "${c}Installing doggo...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mr-karan/doggo/cmd/doggo@latest
    else
        echo -e "${c}Go not found, skipping doggo installation.${r}"
    fi
else
    echo -e "${c}doggo already installed.${r}"
fi

# Curlie (Modern curl)
if ! command -v curlie &> /dev/null; then
    echo -e "${c}Installing curlie...${r}"
    if command -v go &> /dev/null; then
        go install github.com/rs/curlie@latest
    else
        echo -e "${c}Go not found, skipping curlie installation.${r}"
    fi
else
    echo -e "${c}curlie already installed.${r}"
fi

# K9s (Kubernetes CLI)
if ! command -v k9s &> /dev/null; then
    echo -e "${c}Installing k9s...${r}"
    sudo snap install k9s
else
    echo -e "${c}k9s already installed.${r}"
fi

# Glances (System Monitoring)
if ! command -v glances &> /dev/null; then
    echo -e "${c}Installing glances...${r}"
    pip3 install glances[all] --break-system-packages 2>/dev/null || pip3 install glances[all]
else
    echo -e "${c}glances already installed.${r}"
fi

# Oha (HTTP Benchmarking)
install_cargo_crate oha

# Trippy (Network Diagnostic)
install_cargo_crate trippy trip

# Gdu (Disk Usage Analyzer)
if ! command -v gdu &> /dev/null; then
    echo -e "${c}Installing gdu...${r}"
    if command -v go &> /dev/null; then
        go install github.com/dundee/gdu/v5/cmd/gdu@latest
    else
        echo -e "${c}Go not found, skipping gdu installation.${r}"
    fi
else
    echo -e "${c}gdu already installed.${r}"
fi

# Lazysql (SQL Client TUI)
if ! command -v lazysql &> /dev/null; then
    echo -e "${c}Installing lazysql...${r}"
    if command -v go &> /dev/null; then
        go install github.com/jorgerojas26/lazysql@latest
    else
        echo -e "${c}Go not found, skipping lazysql installation.${r}"
    fi
else
    echo -e "${c}lazysql already installed.${r}"
fi

# Pueue (Command Queue Manager)
install_cargo_crate pueue

# Broot (Directory Navigation)
install_cargo_crate broot
if command -v broot &> /dev/null; then
    broot --install
fi

# Presenterm (Terminal Slideshows)
install_cargo_crate presenterm

# Fastfetch (Modern System Info)
if ! command -v fastfetch &> /dev/null; then
    echo -e "${c}Installing fastfetch...${r}"
    sudo add-apt-repository ppa:zhanghua/fastfetch -y
    sudo apt update
    sudo apt install -y fastfetch
else
    echo -e "${c}fastfetch already installed.${r}"
fi

# Ollama (Local AI)
if ! command -v ollama &> /dev/null; then
    echo -e "${c}Installing ollama...${r}"
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo -e "${c}ollama already installed.${r}"
fi

# Posting (HTTP Client TUI)
if ! command -v posting &> /dev/null; then
    echo -e "${c}Installing posting...${r}"
    if command -v uv &> /dev/null; then
        uv tool install posting
    elif command -v pip3 &> /dev/null; then
        pip3 install posting --break-system-packages 2>/dev/null || pip3 install posting
    else
         echo -e "${c}Neither uv nor pip3 found, skipping posting installation.${r}"
    fi
else
    echo -e "${c}posting already installed.${r}"
fi

# Superfile (Modern File Manager)
if ! command -v superfile &> /dev/null; then
    echo -e "${c}Installing superfile...${r}"
    bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
else
    echo -e "${c}superfile already installed.${r}"
fi

# Glow (Markdown Renderer)
if ! command -v glow &> /dev/null; then
    echo -e "${c}Installing glow...${r}"
    if command -v go &> /dev/null; then
        go install github.com/charmbracelet/glow@latest
    else
        echo -e "${c}Go not found, skipping glow installation.${r}"
    fi
else
    echo -e "${c}glow already installed.${r}"
fi

# Slides (Terminal Presentations)
if ! command -v slides &> /dev/null; then
    echo -e "${c}Installing slides...${r}"
    if command -v go &> /dev/null; then
        go install github.com/maaslalani/slides@latest
    else
        echo -e "${c}Go not found, skipping slides installation.${r}"
    fi
else
    echo -e "${c}slides already installed.${r}"
fi

# Fx (JSON Viewer)
if ! command -v fx &> /dev/null; then
    echo -e "${c}Installing fx...${r}"
    if command -v go &> /dev/null; then
        go install github.com/antonmedv/fx@latest
    else
        echo -e "${c}Go not found, skipping fx installation.${r}"
    fi
else
    echo -e "${c}fx already installed.${r}"
fi

# Sd (Search & Displace)
install_cargo_crate sd

# Choose (Human-friendly cut)
install_cargo_crate choose

# Onefetch (Git Summary)
install_cargo_crate onefetch

# Lnav (Log Navigator)
if ! command -v lnav &> /dev/null; then
    echo -e "${c}Installing lnav...${r}"
    sudo apt install -y lnav
else
    echo -e "${c}lnav already installed.${r}"
fi

# Atac (Modern API Client TUI)
install_cargo_crate atac

# Binsider (Binary Analysis TUI)
install_cargo_crate binsider

# Serpl (Search and Replace TUI)
install_cargo_crate serpl

# --- MORE 2026 APPS ---

# Ruff (Fast Python Linter/Formatter)
if ! command -v ruff &> /dev/null; then
    echo -e "${c}Installing ruff...${r}"
    pip3 install ruff --break-system-packages 2>/dev/null || pip3 install ruff
else
    echo -e "${c}ruff already installed.${r}"
fi

# Biome (Fast JS/TS Toolchain)
if ! command -v biome &> /dev/null; then
    echo -e "${c}Installing biome...${r}"
    curl -L https://github.com/biomejs/biome/releases/download/v1.9.4/biome-linux-x64 -o biome
    chmod +x biome
    sudo mv biome /usr/local/bin/biome
else
    echo -e "${c}biome already installed.${r}"
fi

# Helix (Modern Editor)
install_cargo_crate helix-term hx

# Websocat (Netcat for WebSockets)
install_cargo_crate websocat

# Ouch (Painless Compression)
install_cargo_crate ouch

# Tokei (Code Statistics)
install_cargo_crate tokei

# Grex (Regex Generator)
install_cargo_crate grex

# Bandwhich (Bandwidth Monitor)
install_cargo_crate bandwhich

# Jless (JSON Viewer)
install_cargo_crate jless

# Spacer (CLI Spacer)
install_cargo_crate spacer

# --- EVEN MORE 2026 APPS ---

# Sesh (Smart Session Manager)
if ! command -v sesh &> /dev/null; then
    echo -e "${c}Installing sesh...${r}"
    if command -v go &> /dev/null; then
        go install github.com/joshmedeski/sesh@latest
    else
        echo -e "${c}Go not found, skipping sesh installation.${r}"
    fi
else
    echo -e "${c}sesh already installed.${r}"
fi

# Carapace (Multi-shell Completer)
if ! command -v carapace &> /dev/null; then
    echo -e "${c}Installing carapace...${r}"
    if command -v go &> /dev/null; then
        go install github.com/carapace-sh/carapace-bin/cmd/carapace@latest
    else
         echo -e "${c}Go not found, skipping carapace installation.${r}"
    fi
else
    echo -e "${c}carapace already installed.${r}"
fi

# Moar (Better Pager)
if ! command -v moar &> /dev/null; then
    echo -e "${c}Installing moar...${r}"
    if command -v go &> /dev/null; then
        go install github.com/walles/moar@latest
    else
         echo -e "${c}Go not found, skipping moar installation.${r}"
    fi
else
    echo -e "${c}moar already installed.${r}"
fi

# Viddy (Modern Watch)
if ! command -v viddy &> /dev/null; then
    echo -e "${c}Installing viddy...${r}"
    if command -v go &> /dev/null; then
        go install github.com/sachaos/viddy@latest
    else
         echo -e "${c}Go not found, skipping viddy installation.${r}"
    fi
else
    echo -e "${c}viddy already installed.${r}"
fi

# Hurl (HTTP Testing)
install_cargo_crate hurl

# Dasel (Data Query/Update)
if ! command -v dasel &> /dev/null; then
    echo -e "${c}Installing dasel...${r}"
    if command -v go &> /dev/null; then
        go install github.com/TomWright/dasel/v2/cmd/dasel@latest
    else
         echo -e "${c}Go not found, skipping dasel installation.${r}"
    fi
else
    echo -e "${c}dasel already installed.${r}"
fi

# --- ULTIMATE 2026 APPS ---

# Just (Command Runner)
install_cargo_crate just

# Dive (Docker Image Explorer)
if ! command -v dive &> /dev/null; then
    echo -e "${c}Installing dive...${r}"
    if command -v go &> /dev/null; then
        go install github.com/wagoodman/dive@latest
    else
         echo -e "${c}Go not found, skipping dive installation.${r}"
    fi
else
    echo -e "${c}dive already installed.${r}"
fi

# Fq (JQ for binary)
install_cargo_crate fq

# Htmlq (JQ for HTML)
install_cargo_crate htmlq

# Visidata (Terminal Spreadsheet)
if ! command -v vd &> /dev/null; then
    echo -e "${c}Installing visidata...${r}"
    pip3 install visidata --break-system-packages 2>/dev/null || pip3 install visidata
else
    echo -e "${c}visidata already installed.${r}"
fi

# Trash-cli (Safer rm)
if ! command -v trash &> /dev/null; then
    echo -e "${c}Installing trash-cli...${r}"
    pip3 install trash-cli --break-system-packages 2>/dev/null || pip3 install trash-cli
else
    echo -e "${c}trash-cli already installed.${r}"
fi

# Bacon (Background Rust Checker)
install_cargo_crate bacon

# Git-cliff (Changelog Generator)
install_cargo_crate git-cliff

# --- 2026 EYE CANDY & EXTRAS ---

# Pokeget (Terminal Pokemon)
install_go_package github.com/talwat/pokeget@latest pokeget

# Pipes-rs (Screensaver)
install_cargo_crate pipes-rs

# RS-CMatrix (Matrix Effect)
install_cargo_crate rs-cmatrix

# Genact (Activity Generator)
install_cargo_crate genact

# GitUI (Blazing Fast Git TUI)
install_cargo_crate gitui

# Oxker (Docker TUI)
install_cargo_crate oxker

# Kmon (Kernel Monitor)
install_cargo_crate kmon

# Zenith (System Monitor with Charts)
install_cargo_crate zenith

# Gobang (Cross-platform Database Client TUI)
install_cargo_crate gobang

# Termtyper (Typing Practice)
install_cargo_crate termtyper

# Tickrs (Stock Ticker)
install_cargo_crate tickrs

# Tenki (Weather TUI)
install_cargo_crate tenki

# Television (Fast Fuzzy Finder)
install_cargo_crate television tv

# Amber (Search & Replace)
install_cargo_crate amber

# --- NEWEST 2026 APPS ---

# Mcfly (Neural Network Shell History)
install_cargo_crate mcfly

# Monolith (Web Page Saver)
install_cargo_crate monolith

# Bottom (System Monitor)
install_cargo_crate bottom btm

# Nushell (Modern Shell)
install_cargo_crate nu

# Eget (Easy Binary Downloader)
if ! command -v eget &> /dev/null; then
    echo -e "${c}Installing eget...${r}"
    curl https://zyedidia.github.io/eget.sh | sh
    sudo mv eget /usr/local/bin/eget
else
    echo -e "${c}eget already installed.${r}"
fi

# Configure Bat Theme
echo -e "${c}Configuring Bat Theme...${r}"
BAT_CONFIG_DIR="$(bat --config-dir)"
mkdir -p "$BAT_CONFIG_DIR/themes"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BAT_THEME_FILE="$SCRIPT_DIR/themes/bat/synthwave.tmTheme"

if [ -f "$BAT_THEME_FILE" ]; then
    cp "$BAT_THEME_FILE" "$BAT_CONFIG_DIR/themes/synthwave.tmTheme"
    echo -e "${c}Bat theme copied.${r}"
    bat cache --build
    echo -e "${c}Bat cache rebuilt.${r}"
else
    echo -e "${c}Warning: synthwave.tmTheme not found in $SCRIPT_DIR/themes/bat${r}"
fi

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

# Configure Fastfetch
echo -e "${c}Configuring Fastfetch...${r}"
FASTFETCH_CONFIG_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_CONFIG_DIR"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
FASTFETCH_CONFIG_FILE="$SCRIPT_DIR/configs/fastfetch.jsonc"

if [ -f "$FASTFETCH_CONFIG_FILE" ]; then
    ln -sf "$FASTFETCH_CONFIG_FILE" "$FASTFETCH_CONFIG_DIR/config.jsonc"
    echo -e "${c}Fastfetch config linked.${r}"
else
    echo -e "${c}Warning: fastfetch.jsonc not found in $SCRIPT_DIR/configs${r}"
fi

# Configure Btop
echo -e "${c}Configuring Btop...${r}"
BTOP_THEMES_DIR="$HOME/.config/btop/themes"
mkdir -p "$BTOP_THEMES_DIR"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BTOP_THEME_FILE="$SCRIPT_DIR/themes/btop/synthwave.theme"

if [ -f "$BTOP_THEME_FILE" ]; then
    cp "$BTOP_THEME_FILE" "$BTOP_THEMES_DIR/synthwave.theme"
    echo -e "${c}Btop theme copied.${r}"

    # Update btop.conf to use the theme if it exists, or creating a minimal one
    BTOP_CONF="$HOME/.config/btop/btop.conf"
    if [ ! -f "$BTOP_CONF" ]; then
        echo "color_theme = \"$BTOP_THEMES_DIR/synthwave.theme\"" > "$BTOP_CONF"
        echo "theme_background = False" >> "$BTOP_CONF"
        echo "truecolor = True" >> "$BTOP_CONF"
        echo "vim_keys = True" >> "$BTOP_CONF"
    else
        # Replace existing color_theme line or append it
        if grep -q "color_theme" "$BTOP_CONF"; then
            sed -i 's|^color_theme = .*|color_theme = "'"$BTOP_THEMES_DIR"'/synthwave.theme"|' "$BTOP_CONF"
        else
            echo "color_theme = \"$BTOP_THEMES_DIR/synthwave.theme\"" >> "$BTOP_CONF"
        fi
    fi
    echo -e "${c}Btop configured to use Synthwave theme.${r}"
else
    echo -e "${c}Warning: synthwave.theme not found in $SCRIPT_DIR/themes/btop${r}"
fi

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
