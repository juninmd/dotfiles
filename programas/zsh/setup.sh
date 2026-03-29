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
export BAT_THEME="Synthwave '84"
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#343746,hl+:#bd93f9 --color=info:#72f1b8,prompt:#36f9f6,pointer:#ff7edb --color=marker:#ff7edb,spinner:#36f9f6,header:#fede5d'

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
if command -v hwatch &> /dev/null; then alias watch='hwatch'; fi
if command -v sesh &> /dev/null; then alias s='sesh connect'; fi

# --- Interface Improvements 2026 ---
if command -v amber &> /dev/null; then alias search='amber'; fi
if command -v binsider &> /dev/null; then alias analyze='binsider'; fi
if command -v serpl &> /dev/null; then alias sr='serpl'; fi
if command -v tv &> /dev/null; then alias television='tv'; fi
if command -v zenith &> /dev/null; then alias zen='zenith'; fi

# --- Newest 2026 Apps ---
if command -v mcfly &> /dev/null; then
    eval "\$(mcfly init zsh)"
fi
if command -v nu &> /dev/null; then alias nu='nu'; fi
if command -v btm &> /dev/null; then alias btm='btm'; fi
if command -v tspin &> /dev/null; then alias logs='tspin'; fi
if command -v slumber &> /dev/null; then alias http-ui='slumber'; fi
if command -v jqp &> /dev/null; then alias jq-ui='jqp'; fi

# --- Brand New 2026 Apps ---
if command -v kalker &> /dev/null; then alias calc2='kalker'; fi
if command -v ugrep &> /dev/null; then alias ug='ugrep'; fi

# --- Extra 2026 Apps ---
if command -v kdash &> /dev/null; then alias kdash='kdash'; fi
if command -v stern &> /dev/null; then alias stern='stern'; fi
if command -v fabric &> /dev/null; then alias ai='fabric'; fi

# --- Future Tools 2026 ---
if command -v rga &> /dev/null; then alias grepa='rga'; fi
if command -v bore &> /dev/null; then alias tunnel='bore'; fi
if command -v macchina &> /dev/null; then alias sysinfo='macchina'; fi
if command -v typos &> /dev/null; then alias spellcheck='typos'; fi
if command -v cog &> /dev/null; then alias commit='cog commit'; fi
if command -v gron &> /dev/null; then alias unjson='gron'; fi

# --- 2026 Extra CLI Apps ---
if command -v pomsky &> /dev/null; then alias regex-gen='pomsky'; fi
if command -v fend &> /dev/null; then alias calc='fend'; fi
if command -v xc &> /dev/null; then alias tasks-md='xc'; fi
if command -v gtt &> /dev/null; then alias translate='gtt'; fi
if command -v task &> /dev/null; then alias t='task'; fi

# --- 2026 Cutting Edge Apps ---
if command -v sgpt &> /dev/null; then alias chatgpt='sgpt'; fi
if command -v mlr &> /dev/null; then alias data='mlr'; fi
if command -v usql &> /dev/null; then alias dbs='usql'; fi
if command -v joshuto &> /dev/null; then alias fm='joshuto'; fi
if command -v circumflex &> /dev/null; then alias hn='circumflex'; fi
if command -v kubecolor &> /dev/null; then alias kubectl='kubecolor'; fi
if command -v chafa &> /dev/null; then alias img='chafa'; fi
if command -v lsd &> /dev/null; then alias ls2='lsd'; fi
if command -v dprint &> /dev/null; then alias fmt='dprint'; fi

# --- 2026 AI Apps ---
if command -v harlequin &> /dev/null; then alias sql-ide='harlequin'; fi
if command -v gitingest &> /dev/null; then alias ingest='gitingest'; fi
if command -v repomix &> /dev/null; then alias repo-pack='repomix'; fi
if command -v tenv &> /dev/null; then alias tf-env='tenv'; fi

# --- Bonus 2026 Apps ---
if command -v tgpt &> /dev/null; then alias ai-free='tgpt'; fi
if command -v silicon &> /dev/null; then alias img-code='silicon'; fi
if command -v rip &> /dev/null; then alias del='rip'; fi
if command -v ruplacer &> /dev/null; then alias replace-all='ruplacer'; fi
if command -v igrep &> /dev/null; then alias interactive-grep='igrep'; fi

# --- Ultimate 2026 Tools ---
if command -v serie &> /dev/null; then alias git-timeline='serie'; fi
if command -v ttyper &> /dev/null; then alias typer='ttyper'; fi
if command -v mdcat &> /dev/null; then alias mdview='mdcat'; fi
if command -v code2prompt &> /dev/null; then alias c2p='code2prompt'; fi
if command -v oxlint &> /dev/null; then alias ox='oxlint'; fi

# --- Missing 2026 Aliases ---
if command -v yazi &> /dev/null; then alias y='yazi'; fi
if command -v gping &> /dev/null; then alias ping='gping'; fi
if command -v trip &> /dev/null; then alias traceroute='trip'; fi
if command -v broot &> /dev/null; then alias br='broot'; fi
if command -v pueue &> /dev/null; then alias pq='pueue'; fi
if command -v hyperfine &> /dev/null; then alias hf='hyperfine'; fi

# --- New 2026 Apps ---
if command -v ctop &> /dev/null; then alias docker-top='ctop'; fi
if command -v http &> /dev/null; then alias http='http'; fi
if command -v croc &> /dev/null; then alias send='croc'; fi
if command -v dufs &> /dev/null; then alias share='dufs'; fi
if command -v cheat &> /dev/null; then alias cheatsheet='cheat'; fi

# --- Latest 2026 Apps ---
if command -v yt-dlp &> /dev/null; then alias ytdl='yt-dlp'; fi
if command -v porsmo &> /dev/null; then alias pomodoro='porsmo'; fi
if command -v rustscan &> /dev/null; then alias rscan='rustscan'; fi
if command -v diskonaut &> /dev/null; then alias disk-vis='diskonaut'; fi

# --- Cutting-Edge 2026 Apps ---
if command -v lazynpm &> /dev/null; then alias lnpm='lazynpm'; fi
if command -v k8sgpt &> /dev/null; then alias k8s-ai='k8sgpt'; fi
if command -v git-town &> /dev/null; then alias gt='git-town'; fi
if command -v kubectx &> /dev/null; then alias kx='kubectx'; fi
if command -v kubens &> /dev/null; then alias kn='kubens'; fi
if command -v gh &> /dev/null && gh dash --help &> /dev/null; then alias ghd='gh dash'; fi

# --- DevOps & JS 2026 Apps ---
if command -v fnm &> /dev/null; then eval "\$(fnm env --use-on-cd)"; fi
if command -v pnpm &> /dev/null; then alias npm-fast='pnpm'; fi
if command -v k3d &> /dev/null; then alias k8s-docker='k3d'; fi
if command -v helm &> /dev/null; then alias k8s-pkg='helm'; fi
if command -v kustomize &> /dev/null; then alias k8s-config='kustomize'; fi
if command -v ngrok &> /dev/null; then alias proxy='ngrok'; fi

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
if command -v hwatch &> /dev/null; then alias watch='hwatch'; fi
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
if command -v zenith &> /dev/null; then alias zen='zenith'; fi
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

# Check if Newest 2026 Apps are present in .zshrc
if ! grep -q "# --- Newest 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Newest 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Newest 2026 Apps ---
if command -v mcfly &> /dev/null; then
    eval "\$(mcfly init zsh)"
fi
if command -v nu &> /dev/null; then alias nu='nu'; fi
if command -v btm &> /dev/null; then alias btm='btm'; fi
if command -v tspin &> /dev/null; then alias logs='tspin'; fi
if command -v slumber &> /dev/null; then alias http-ui='slumber'; fi
if command -v jqp &> /dev/null; then alias jq-ui='jqp'; fi
EOT
fi

# Check if The Future is Now Apps are present in .zshrc
if ! grep -q "# --- The Future is Now Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending The Future is Now Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- The Future is Now Apps ---
export DENO_INSTALL="\$HOME/.deno"
export PATH="\$DENO_INSTALL/bin:\$PATH"

if command -v wiki-tui &> /dev/null; then alias wiki='wiki-tui'; fi
if command -v aichat &> /dev/null; then alias chat='aichat'; fi
if command -v cointop &> /dev/null; then alias crypto='cointop'; fi
if command -v wtf &> /dev/null; then alias dashboard='wtf'; fi
if command -v taskwarrior-tui &> /dev/null; then alias tasks='taskwarrior-tui'; fi
if command -v nap &> /dev/null; then alias snippets='nap'; fi
if command -v kondo &> /dev/null; then alias clean='kondo'; fi
EOT
fi

# Check if 2026 Apps Part II are present in .zshrc
if ! grep -q "# --- 2026 Apps Part II ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 Apps Part II to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 Apps Part II ---
if command -v duckdb &> /dev/null; then alias sql-local='duckdb'; fi
if command -v d2 &> /dev/null; then alias diagrams='d2'; fi
if command -v vhs &> /dev/null; then alias record='vhs'; fi
if command -v freeze &> /dev/null; then alias screenshot='freeze'; fi
if command -v rnr &> /dev/null; then alias rename='rnr'; fi
if command -v erd &> /dev/null; then alias tree='erd'; fi
if command -v dua &> /dev/null; then alias disk='dua i'; fi
if command -v mprocs &> /dev/null; then alias process='mprocs'; fi
EOT
fi

# Check if 2026 Apps Part III are present in .zshrc
if ! grep -q "# --- 2026 Apps Part III ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 Apps Part III to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 Apps Part III ---
if command -v topgrade &> /dev/null; then alias update='topgrade'; fi
if command -v hexyl &> /dev/null; then alias hex='hexyl'; fi
if command -v pastel &> /dev/null; then alias color='pastel'; fi
if command -v csvlens &> /dev/null; then alias csv='csvlens'; fi
EOT
fi

# Check if Extra 2026 Apps are present in .zshrc
if ! grep -q "# --- Extra 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Extra 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Extra 2026 Apps ---
if command -v kdash &> /dev/null; then alias kdash='kdash'; fi
if command -v stern &> /dev/null; then alias stern='stern'; fi
if command -v fabric &> /dev/null; then alias ai='fabric'; fi
EOT
fi

# Check if Future Tools 2026 are present in .zshrc
if ! grep -q "# --- Future Tools 2026 ---" "$ZSHRC"; then
    echo -e "${c}Appending Future Tools 2026 to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Future Tools 2026 ---
if command -v rga &> /dev/null; then alias grepa='rga'; fi
if command -v bore &> /dev/null; then alias tunnel='bore'; fi
if command -v macchina &> /dev/null; then alias sysinfo='macchina'; fi
if command -v typos &> /dev/null; then alias spellcheck='typos'; fi
if command -v cog &> /dev/null; then alias commit='cog commit'; fi
if command -v gron &> /dev/null; then alias unjson='gron'; fi
EOT
fi

# Check if 2026 Extra CLI Apps are present in .zshrc
if ! grep -q "# --- 2026 Extra CLI Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 Extra CLI Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 Extra CLI Apps ---
if command -v pomsky &> /dev/null; then alias regex-gen='pomsky'; fi
if command -v fend &> /dev/null; then alias calc='fend'; fi
if command -v xc &> /dev/null; then alias tasks-md='xc'; fi
if command -v gtt &> /dev/null; then alias translate='gtt'; fi
if command -v task &> /dev/null; then alias t='task'; fi
EOT
fi

# Check if 2026 Cutting Edge Apps are present in .zshrc
if ! grep -q "# --- 2026 Cutting Edge Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 Cutting Edge Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 Cutting Edge Apps ---
if command -v sgpt &> /dev/null; then alias chatgpt='sgpt'; fi
if command -v mlr &> /dev/null; then alias data='mlr'; fi
if command -v usql &> /dev/null; then alias dbs='usql'; fi
if command -v joshuto &> /dev/null; then alias fm='joshuto'; fi
if command -v circumflex &> /dev/null; then alias hn='circumflex'; fi
if command -v kubecolor &> /dev/null; then alias kubectl='kubecolor'; fi
if command -v chafa &> /dev/null; then alias img='chafa'; fi
if command -v lsd &> /dev/null; then alias ls2='lsd'; fi
if command -v dprint &> /dev/null; then alias fmt='dprint'; fi
if command -v kubectx &> /dev/null; then alias kx='kubectx'; fi
if command -v kubens &> /dev/null; then alias kn='kubens'; fi
if command -v gh &> /dev/null && gh dash --help &> /dev/null; then alias ghd='gh dash'; fi
EOT
fi

# Check if 2026 AI Apps are present in .zshrc
if ! grep -q "# --- 2026 AI Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending 2026 AI Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- 2026 AI Apps ---
if command -v harlequin &> /dev/null; then alias sql-ide='harlequin'; fi
if command -v gitingest &> /dev/null; then alias ingest='gitingest'; fi
if command -v repomix &> /dev/null; then alias repo-pack='repomix'; fi
if command -v tenv &> /dev/null; then alias tf-env='tenv'; fi
EOT
fi

# Check if Bonus 2026 Apps are present in .zshrc
if ! grep -q "# --- Bonus 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Bonus 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Bonus 2026 Apps ---
if command -v tgpt &> /dev/null; then alias ai-free='tgpt'; fi
if command -v silicon &> /dev/null; then alias img-code='silicon'; fi
if command -v rip &> /dev/null; then alias del='rip'; fi
if command -v ruplacer &> /dev/null; then alias replace-all='ruplacer'; fi
if command -v igrep &> /dev/null; then alias interactive-grep='igrep'; fi
EOT
fi

# Check if Ultimate 2026 Tools are present in .zshrc
if ! grep -q "# --- Ultimate 2026 Tools ---" "$ZSHRC"; then
    echo -e "${c}Appending Ultimate 2026 Tools to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Ultimate 2026 Tools ---
if command -v serie &> /dev/null; then alias git-timeline='serie'; fi
if command -v ttyper &> /dev/null; then alias typer='ttyper'; fi
if command -v mdcat &> /dev/null; then alias mdview='mdcat'; fi
if command -v code2prompt &> /dev/null; then alias c2p='code2prompt'; fi
if command -v oxlint &> /dev/null; then alias ox='oxlint'; fi
EOT
fi

# Check if Missing 2026 Aliases are present in .zshrc
if ! grep -q "# --- Missing 2026 Aliases ---" "$ZSHRC"; then
    echo -e "${c}Appending Missing 2026 Aliases to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Missing 2026 Aliases ---
if command -v yazi &> /dev/null; then alias y='yazi'; fi
if command -v gping &> /dev/null; then alias ping='gping'; fi
if command -v trip &> /dev/null; then alias traceroute='trip'; fi
if command -v broot &> /dev/null; then alias br='broot'; fi
if command -v pueue &> /dev/null; then alias pq='pueue'; fi
if command -v hyperfine &> /dev/null; then alias hf='hyperfine'; fi
EOT
fi

# Check if New 2026 Apps are present in .zshrc
if ! grep -q "# --- New 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending New 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- New 2026 Apps ---
if command -v ctop &> /dev/null; then alias docker-top='ctop'; fi
if command -v http &> /dev/null; then alias http='http'; fi
if command -v croc &> /dev/null; then alias send='croc'; fi
if command -v dufs &> /dev/null; then alias share='dufs'; fi
if command -v cheat &> /dev/null; then alias cheatsheet='cheat'; fi
EOT
fi

# Check if Latest 2026 Apps are present in .zshrc
if ! grep -q "# --- Latest 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Latest 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Latest 2026 Apps ---
if command -v yt-dlp &> /dev/null; then alias ytdl='yt-dlp'; fi
if command -v porsmo &> /dev/null; then alias pomodoro='porsmo'; fi
if command -v rustscan &> /dev/null; then alias rscan='rustscan'; fi
if command -v diskonaut &> /dev/null; then alias disk-vis='diskonaut'; fi
EOT
fi

# Check if Cutting-Edge 2026 Apps are present in .zshrc
if ! grep -q "# --- Cutting-Edge 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Cutting-Edge 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Cutting-Edge 2026 Apps ---
if command -v lazynpm &> /dev/null; then alias lnpm='lazynpm'; fi
if command -v k8sgpt &> /dev/null; then alias k8s-ai='k8sgpt'; fi
if command -v git-town &> /dev/null; then alias gt='git-town'; fi
EOT
fi

# Check if Extra 2026 Apps are present in .zshrc
if ! grep -q "# --- More 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending More 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- More 2026 Apps ---
if command -v sniffnet &> /dev/null; then alias net-vis='sniffnet'; fi
if command -v jc &> /dev/null; then alias to-json='jc'; fi
if command -v hwatch &> /dev/null; then alias hwatch='hwatch'; fi
EOT
fi

# Check if Hyper-Modern 2026 Apps are present in .zshrc
if ! grep -q "# --- Hyper-Modern 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Hyper-Modern 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Hyper-Modern 2026 Apps ---
if command -v jj &> /dev/null; then alias git-next='jj'; fi
if command -v trivy &> /dev/null; then alias scan-container='trivy'; fi
if command -v earthly &> /dev/null; then alias build='earthly'; fi
if command -v kind &> /dev/null; then alias local-k8s='kind'; fi
if command -v hck &> /dev/null; then alias cut2='hck'; fi
if command -v cloudflared &> /dev/null; then alias cf-tunnel='cloudflared tunnel'; fi
EOT
fi

# Check if DevOps & JS 2026 Apps are present in .zshrc
if ! grep -q "# --- DevOps & JS 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending DevOps & JS 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- DevOps & JS 2026 Apps ---
if command -v fnm &> /dev/null; then eval "\$(fnm env --use-on-cd)"; fi
if command -v pnpm &> /dev/null; then alias npm-fast='pnpm'; fi
if command -v k3d &> /dev/null; then alias k8s-docker='k3d'; fi
if command -v helm &> /dev/null; then alias k8s-pkg='helm'; fi
if command -v kustomize &> /dev/null; then alias k8s-config='kustomize'; fi
if command -v ngrok &> /dev/null; then alias proxy='ngrok'; fi
EOT
fi

# Check if Newest 2026 Apps are present in .zshrc
if ! grep -q "# --- Newest 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Newest 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Newest 2026 Apps ---
if command -v jo &> /dev/null; then alias json-out='jo'; fi
if command -v k6 &> /dev/null; then alias loadtest='k6'; fi
if command -v dolt &> /dev/null; then alias data-git='dolt'; fi
if command -v turso &> /dev/null; then alias db-edge='turso'; fi
if command -v flyctl &> /dev/null; then alias cloud-deploy='flyctl'; fi
EOT
fi

# Check if Brand New 2026 Apps are present in .zshrc
if ! grep -q "# --- Brand New 2026 Apps ---" "$ZSHRC"; then
    echo -e "${c}Appending Brand New 2026 Apps to .zshrc...${r}"
    cat <<EOT >> $ZSHRC

# --- Brand New 2026 Apps ---
if command -v kalker &> /dev/null; then alias calc2='kalker'; fi
if command -v ugrep &> /dev/null; then alias ug='ugrep'; fi
EOT
fi

# Update zoxide to use cd alias if present in existing config
sed -i 's/eval "$(zoxide init zsh)"/eval "$(zoxide init zsh --cmd cd)"/' "$ZSHRC"

echo -e "${c}Zsh configured! Please restart your terminal or run 'source ~/.zshrc'.${r}"
