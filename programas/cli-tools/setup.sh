#!/bin/bash
c='\e[32m' # Green Color
r='tput sgr0' # Reset Color

echo -e "${c}Installing Modern CLI Tools...${r}"

# Update apt first
sudo apt update

# Install dependencies for adding repos
sudo apt install -y wget gpg

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

# Tldr (Simplified man pages)
echo -e "${c}Installing tldr...${r}"
sudo apt install -y tldr

# --- NEW TOOLS (2026 Apps) ---

# Check for Cargo (Rust)
if ! command -v cargo &> /dev/null; then
    echo -e "${c}Cargo not found. Installing Rust...${r}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Yazi (Modern File Manager)
if ! command -v yazi &> /dev/null; then
    echo -e "${c}Installing yazi...${r}"
    cargo install --locked yazi-fm yazi-cli
else
    echo -e "${c}yazi already installed.${r}"
fi

# Zellij (Terminal Workspace)
if ! command -v zellij &> /dev/null; then
    echo -e "${c}Installing zellij...${r}"
    cargo install --locked zellij
else
    echo -e "${c}zellij already installed.${r}"
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

# The Fuck (Command Corrector)
if ! command -v thefuck &> /dev/null; then
    echo -e "${c}Installing thefuck...${r}"
    pip3 install thefuck --break-system-packages 2>/dev/null || pip3 install thefuck
else
    echo -e "${c}thefuck already installed.${r}"
fi

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
