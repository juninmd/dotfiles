#!/bin/bash
c='\e[32m'
r='tput sgr0'

echo -e "${c}Configuring Zsh...${r}"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${c}Installing Oh My Zsh...${r}"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${c}Oh My Zsh already installed.${r}"
fi

# Define custom plugin directory
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "${c}Installing zsh-autosuggestions...${r}"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
    echo -e "${c}zsh-autosuggestions already installed.${r}"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${c}Installing zsh-syntax-highlighting...${r}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
    echo -e "${c}zsh-syntax-highlighting already installed.${r}"
fi

# Configure .zshrc
ZSHRC="$HOME/.zshrc"

if grep -q "# --- Custom Configuration (Added by dotfiles setup) ---" "$ZSHRC"; then
    echo -e "${c}Custom configuration already present in .zshrc. Skipping append.${r}"
else
    echo -e "${c}Updating .zshrc...${r}"
    cp $ZSHRC "$ZSHRC.backup.$(date +%F_%T)"

    cat <<EOT >> $ZSHRC

# --- Custom Configuration (Added by dotfiles setup) ---

# Starship Prompt
if command -v starship &> /dev/null; then
    eval "\$(starship init zsh)"
fi

# Zoxide (cd replacement)
if command -v zoxide &> /dev/null; then
    eval "\$(zoxide init zsh)"
fi

# Aliases for Modern Tools
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
    alias lt='eza --tree --level=2 --icons'
fi

if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v btop &> /dev/null; then
    alias top='btop'
fi

if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

# New 2026 Apps Integrations

if command -v zellij &> /dev/null; then
    eval "\$(zellij setup --generate-completion zsh)"
fi

if command -v navi &> /dev/null; then
    eval "\$(navi widget zsh)"
fi

if command -v thefuck &> /dev/null; then
    eval "\$(thefuck --alias)"
fi

if command -v dust &> /dev/null; then
    alias du='dust'
fi

if command -v duf &> /dev/null; then
    alias df='duf'
fi

# Plugins (sourcing directly)
[ -f $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Path for local binaries
export PATH="\$HOME/.local/bin:\$HOME/.cargo/bin:\$HOME/go/bin:\$PATH"
export PATH="\$HOME/.bun/bin:\$PATH"

# --- End Custom Configuration ---
EOT
fi

echo -e "${c}Zsh configured! Please restart your terminal or run 'source ~/.zshrc'.${r}"
