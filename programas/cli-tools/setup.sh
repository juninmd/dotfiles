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

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin is in your PATH.${r}"
