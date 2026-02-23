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

# Install fzf-tab
if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
    echo -e "${c}Installing fzf-tab...${r}"
    git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab
else
    echo -e "${c}fzf-tab already installed.${r}"
fi

# Install zsh-vi-mode
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    echo -e "${c}Installing zsh-vi-mode...${r}"
    git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
else
    echo -e "${c}zsh-vi-mode already installed.${r}"
fi

# Install zsh-you-should-use
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-you-should-use" ]; then
    echo -e "${c}Installing zsh-you-should-use...${r}"
    git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_CUSTOM/plugins/zsh-you-should-use
else
    echo -e "${c}zsh-you-should-use already installed.${r}"
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
    eval "\$(zoxide init zsh --cmd cd)"
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

if command -v atuin &> /dev/null; then
    eval "\$(atuin init zsh)"
fi

if command -v mise &> /dev/null; then
    eval "\$(mise activate zsh)"
fi

if command -v procs &> /dev/null; then
    alias ps='procs'
fi

if command -v doggo &> /dev/null; then
    alias dig='doggo'
fi

if command -v curlie &> /dev/null; then
    alias curl='curlie'
fi

if command -v oha &> /dev/null; then
    alias bench='oha'
fi

if command -v trip &> /dev/null; then
    alias trace='trip'
fi

if command -v lazysql &> /dev/null; then
    alias sql='lazysql'
fi

if command -v fastfetch &> /dev/null; then
    alias pf='fastfetch'
fi

if command -v posting &> /dev/null; then
    alias post='posting'
fi

if command -v superfile &> /dev/null; then
    alias sf='superfile'
fi

# Aesthetics
export BAT_THEME="Dracula"
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Plugins (sourcing directly)
[ -f $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh ] && source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh
[ -f $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f $ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && source $ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
[ -f $ZSH_CUSTOM/plugins/zsh-you-should-use/you-should-use.plugin.zsh ] && source $ZSH_CUSTOM/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# fzf-tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always \$realpath'
zstyle ':fzf-tab:complete:(__git_checkout|git-checkout):*' fzf-preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" \$word'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=\$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status \$word 2> /dev/null'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Path for local binaries
export PATH="\$HOME/.local/bin:\$HOME/.cargo/bin:\$HOME/go/bin:\$PATH"
export PATH="\$HOME/.bun/bin:\$PATH"

# Auto-run fastfetch or pokeget
if command -v pokeget &> /dev/null; then
    pokeget random --hide-name
elif command -v fastfetch &> /dev/null; then
    fastfetch
fi

# --- 2026 Extras ---
if command -v glow &> /dev/null; then alias md='glow'; fi
if command -v fx &> /dev/null; then alias json='fx'; fi
if command -v sd &> /dev/null; then alias replace='sd'; fi
if command -v choose &> /dev/null; then alias pick='choose'; fi
if command -v onefetch &> /dev/null; then alias git-summary='onefetch'; fi

# --- More 2026 Extras ---
if command -v websocat &> /dev/null; then alias ws='websocat'; fi
if command -v ouch &> /dev/null; then
    alias compress='ouch compress'
    alias decompress='ouch decompress'
fi
if command -v tokei &> /dev/null; then alias cloc='tokei'; fi
if command -v bandwhich &> /dev/null; then alias bw='sudo bandwhich'; fi
if command -v grex &> /dev/null; then alias regex='grex'; fi
if command -v jless &> /dev/null; then alias jl='jless'; fi

# --- Even More 2026 Extras ---
if command -v carapace &> /dev/null; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense,xdg'
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi
if command -v moar &> /dev/null; then
    export PAGER='moar'
    export MOAR='--statusbar=bold --no-linenumbers'
    alias less='moar'
fi
if command -v viddy &> /dev/null; then alias watch='viddy'; fi
if command -v sesh &> /dev/null; then alias s='sesh connect'; fi

# --- Interface Improvements 2026 ---
if command -v amber &> /dev/null; then alias search='amber'; fi
if command -v binsider &> /dev/null; then alias analyze='binsider'; fi
if command -v serpl &> /dev/null; then alias sr='serpl'; fi
if command -v tv &> /dev/null; then alias television='tv'; fi

# --- End Custom Configuration ---
EOT
fi

# Check if 2026 Extras are present in .zshrc (for existing users)
if ! grep -q "# --- 2026 Extras ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 Extras to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 Extras ---
if command -v glow &> /dev/null; then alias md='glow'; fi
if command -v fx &> /dev/null; then alias json='fx'; fi
if command -v sd &> /dev/null; then alias replace='sd'; fi
if command -v choose &> /dev/null; then alias pick='choose'; fi
if command -v onefetch &> /dev/null; then alias git-summary='onefetch'; fi
EOT
fi

# Check if More 2026 Extras are present in .zshrc
if ! grep -q "# --- More 2026 Extras ---" "$ZSHRC"; then
    echo -e "${c}Appending More 2026 Extras to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- More 2026 Extras ---
if command -v websocat &> /dev/null; then alias ws='websocat'; fi
if command -v ouch &> /dev/null; then
    alias compress='ouch compress'
    alias decompress='ouch decompress'
fi
if command -v tokei &> /dev/null; then alias cloc='tokei'; fi
if command -v bandwhich &> /dev/null; then alias bw='sudo bandwhich'; fi
if command -v grex &> /dev/null; then alias regex='grex'; fi
if command -v jless &> /dev/null; then alias jl='jless'; fi
EOT
fi

# Check if Even More 2026 Extras are present in .zshrc
if ! grep -q "# --- Even More 2026 Extras ---" "$ZSHRC"; then
    echo -e "${c}Appending Even More 2026 Extras to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Even More 2026 Extras ---
if command -v carapace &> /dev/null; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense,xdg'
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi
if command -v moar &> /dev/null; then
    export PAGER='moar'
    export MOAR='--statusbar=bold --no-linenumbers'
    alias less='moar'
fi
if command -v viddy &> /dev/null; then alias watch='viddy'; fi
if command -v sesh &> /dev/null; then alias s='sesh connect'; fi
EOT
fi

# Check if Eye Candy & 2026 Apps are present in .zshrc
if ! grep -q "# --- Eye Candy & 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Eye Candy & 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Eye Candy & 2026 Apps ---
if command -v gitui &> /dev/null; then alias gu='gitui'; fi
if command -v oxker &> /dev/null; then alias docker-ui='oxker'; fi
if command -v zenith &> /dev/null; then alias top='zenith'; fi
if command -v gobang &> /dev/null; then alias db='gobang'; fi
if command -v tenki &> /dev/null; then alias weather='tenki'; fi
if command -v tickrs &> /dev/null; then alias stocks='tickrs'; fi
EOT
fi

# Check if Interface Improvements 2026 are present in .zshrc
if ! grep -q "# --- Interface Improvements 2026 ---" "$ZSHRC"; then
    echo -e "${c}Appending Interface Improvements 2026 to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Interface Improvements 2026 ---
if command -v amber &> /dev/null; then alias search='amber'; fi
if command -v binsider &> /dev/null; then alias analyze='binsider'; fi
if command -v serpl &> /dev/null; then alias sr='serpl'; fi
if command -v tv &> /dev/null; then alias television='tv'; fi
EOT
fi

# Update zoxide to use cd alias if present in existing config
sed -i 's/eval "$(zoxide init zsh)"/eval "$(zoxide init zsh --cmd cd)"/' "$ZSHRC"

echo -e "${c}Zsh configured! Please restart your terminal or run 'source ~/.zshrc'.${r}"
