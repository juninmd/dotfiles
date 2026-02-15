#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing Modern CLI Tools...${r}"

# Update apt first
sudo apt update

# Install dependencies for adding repos and essential build tools
sudo apt install -y wget gpg python3-pip golang-go curl unzip

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
if ! command -v tldr &> /dev/null || ! tldr --version | grep -q 'tealdeer'; then
    echo -e "${c}Installing tealdeer (tldr)...${r}"
    cargo install tealdeer
    # Initialize cache
    if command -v tldr &> /dev/null; then
        tldr --update &> /dev/null &
    fi
else
    echo -e "${c}tealdeer already installed.${r}"
fi

# --- NEW TOOLS (2026 Apps) ---

# Check for Cargo (Rust)
if ! command -v cargo &> /dev/null; then
    echo -e "${c}Cargo not found. Installing Rust...${r}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Uv (Extremely fast Python package manager)
if ! command -v uv &> /dev/null; then
    echo -e "${c}Installing uv...${r}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo -e "${c}uv already installed.${r}"
fi

# Gping (Ping with a graph)
if ! command -v gping &> /dev/null; then
    echo -e "${c}Installing gping...${r}"
    cargo install gping
else
    echo -e "${c}gping already installed.${r}"
fi

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
if ! command -v xh &> /dev/null; then
    echo -e "${c}Installing xh...${r}"
    cargo install xh
else
    echo -e "${c}xh already installed.${r}"
fi

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
if ! command -v dust &> /dev/null; then
    echo -e "${c}Installing dust...${r}"
    cargo install du-dust
else
    echo -e "${c}dust already installed.${r}"
fi

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
if ! command -v delta &> /dev/null; then
    echo -e "${c}Installing git-delta...${r}"
    cargo install git-delta
else
    echo -e "${c}git-delta already installed.${r}"
fi

# Navi (Interactive Cheatsheet)
if ! command -v navi &> /dev/null; then
    echo -e "${c}Installing navi...${r}"
    cargo install --locked navi
else
    echo -e "${c}navi already installed.${r}"
fi

# Atuin (Magical Shell History)
if ! command -v atuin &> /dev/null; then
    echo -e "${c}Installing atuin...${r}"
    cargo install atuin
else
    echo -e "${c}atuin already installed.${r}"
fi

# Procs (Modern ps)
if ! command -v procs &> /dev/null; then
    echo -e "${c}Installing procs...${r}"
    cargo install procs
else
    echo -e "${c}procs already installed.${r}"
fi

# Hyperfine (Benchmarking)
if ! command -v hyperfine &> /dev/null; then
    echo -e "${c}Installing hyperfine...${r}"
    cargo install hyperfine
else
    echo -e "${c}hyperfine already installed.${r}"
fi

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
if ! command -v oha &> /dev/null; then
    echo -e "${c}Installing oha...${r}"
    cargo install oha
else
    echo -e "${c}oha already installed.${r}"
fi

# Trippy (Network Diagnostic)
if ! command -v trip &> /dev/null; then
    echo -e "${c}Installing trippy...${r}"
    cargo install trippy
else
    echo -e "${c}trippy already installed.${r}"
fi

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
if ! command -v pueue &> /dev/null; then
    echo -e "${c}Installing pueue...${r}"
    cargo install pueue
else
    echo -e "${c}pueue already installed.${r}"
fi

# Broot (Directory Navigation)
if ! command -v broot &> /dev/null; then
    echo -e "${c}Installing broot...${r}"
    cargo install broot
    # Install broot shell function
    if command -v broot &> /dev/null; then
        broot --install
    fi
else
    echo -e "${c}broot already installed.${r}"
fi

# Presenterm (Terminal Slideshows)
if ! command -v presenterm &> /dev/null; then
    echo -e "${c}Installing presenterm...${r}"
    cargo install presenterm
else
    echo -e "${c}presenterm already installed.${r}"
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

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
