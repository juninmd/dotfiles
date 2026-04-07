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

# Cpufetch (Simple yet fancy CPU architecture fetching tool)
if ! command -v cpufetch &> /dev/null; then
    echo -e "${c}Installing cpufetch...${r}"
    case "$(uname -m)" in
        x86_64) BIN_ARCH="x86_64" ;;
        aarch64) BIN_ARCH="arm64" ;;
        *) BIN_ARCH="x86_64" ;;
    esac
    curl -fsSL "https://github.com/Dr-Noob/cpufetch/releases/latest/download/cpufetch-linux-${BIN_ARCH}" -o /tmp/cpufetch
    sudo mv /tmp/cpufetch /usr/local/bin/cpufetch
    sudo chmod +x /usr/local/bin/cpufetch
else
    echo -e "${c}cpufetch already installed.${r}"
fi

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

# GH (GitHub CLI)
install_go_package github.com/cli/cli/v2/cmd/gh@latest gh
if command -v gh &> /dev/null; then
    echo -e "${c}Installing gh-dash extension...${r}"
    gh extension install dlvhdr/gh-dash 2>/dev/null || true
fi

# Glab (GitLab CLI)
install_go_package gitlab.com/gitlab-org/cli/cmd/glab@latest glab

# Act (Run GitHub Actions Locally)
install_go_package github.com/nektos/act@latest act

# Ast-grep (AST-based search and replace)
install_cargo_crate ast-grep sg

# Sad (CLI search and replace)
install_cargo_crate sad

# Jaq (JQ clone in Rust)
install_cargo_crate jaq

# Jnv (Interactive JQ filter)
install_cargo_crate jnv

# Watchexec (Execute commands in response to file modifications)
install_cargo_crate watchexec-cli watchexec

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

# Tailspin (Log Highlighter)
install_cargo_crate tailspin tspin

# Slumber (Terminal HTTP Client)
install_cargo_crate slumber

# JQP (TUI for jq)
install_go_package github.com/noahgorstein/jqp@latest jqp

# --- THE FUTURE IS NOW (New 2026 Apps) ---

# Deno (Modern JS/TS Runtime)
if ! command -v deno &> /dev/null; then
    echo -e "${c}Installing Deno...${r}"
    curl -fsSL https://deno.land/x/install/install.sh | sh
else
    echo -e "${c}deno already installed.${r}"
fi

# Nap (Snippets Manager)
install_go_package github.com/charmbracelet/nap@latest nap

# Wiki-tui (Wikipedia in terminal)
install_cargo_crate wiki-tui

# Taskwarrior-tui (Productivity)
install_cargo_crate taskwarrior-tui

# Kondo (Cleaner)
install_cargo_crate kondo

# Aichat (AI Chat)
install_cargo_crate aichat

# Cointop (Crypto Tracking)
install_go_package github.com/cointop-sh/cointop@latest cointop

# Wtfutil (Personal Dashboard)
install_go_package github.com/wtfutil/wtf@latest wtf

# --- 2026 APPS PART II ---

# DuckDB (In-process SQL OLAP DBMS)
if ! command -v duckdb &> /dev/null; then
    echo -e "${c}Installing duckdb...${r}"
    wget -q https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip -O /tmp/duckdb.zip
    unzip -o -q /tmp/duckdb.zip -d /tmp
    sudo mv /tmp/duckdb /usr/local/bin/duckdb
    rm /tmp/duckdb.zip
else
    echo -e "${c}duckdb already installed.${r}"
fi

# D2 (Declarative Diagramming)
if ! command -v d2 &> /dev/null; then
    echo -e "${c}Installing d2...${r}"
    curl -fsSL https://d2lang.com/install.sh | sh -s --
else
    echo -e "${c}d2 already installed.${r}"
fi

# VHS (Terminal GIF Recorder)
install_go_package github.com/charmbracelet/vhs@latest vhs

# Freeze (Code Screenshots)
install_go_package github.com/charmbracelet/freeze@latest freeze

# Rnr (Safe File Renamer)
install_cargo_crate rnr

# Erdtree (File-tree Visualizer)
install_cargo_crate erdtree erd

# Dua-cli (Disk Usage Analyzer)
install_cargo_crate dua-cli dua

# Mprocs (Process Manager)
install_cargo_crate mprocs

# --- EXTRA 2026 APPS ---

# Serie (Git commit graph)
install_cargo_crate serie

# Ttyper (Terminal typing practice)
install_cargo_crate ttyper

# Mdcat (Markdown viewer)
install_cargo_crate mdcat

# Code2prompt (Convert codebase to AI prompt)
install_cargo_crate code2prompt

# Llm (CLI for Large Language Models)
if ! command -v llm &> /dev/null; then
    echo -e "${c}Installing llm...${r}"
    if command -v uv &> /dev/null; then
        uv tool install llm
    elif command -v pip3 &> /dev/null; then
        pip3 install llm --break-system-packages 2>/dev/null || pip3 install llm
    else
        echo -e "${c}Neither uv nor pip3 found, skipping llm installation.${r}"
    fi
else
    echo -e "${c}llm already installed.${r}"
fi

# Oxlint (Fast JS/TS linter)
install_cargo_crate oxlint

# Kdash (Kubernetes Dashboard)
install_cargo_crate kdash

# Stern (Multi pod logs)
install_go_package github.com/stern/stern@latest stern

# Fabric (AI CLI framework)
install_go_package github.com/danielmiessler/fabric@latest fabric

# Difftastic (Structural diff)
install_cargo_crate difftastic difft

# Aider-chat (AI pair programming)
if ! command -v aider &> /dev/null; then
    echo -e "${c}Installing aider-chat...${r}"
    pip3 install aider-chat --break-system-packages 2>/dev/null || pip3 install aider-chat
else
    echo -e "${c}aider-chat already installed.${r}"
fi

# Direnv (Environment variable manager)
if ! command -v direnv &> /dev/null; then
    echo -e "${c}Installing direnv...${r}"
    sudo apt install -y direnv
else
    echo -e "${c}direnv already installed.${r}"
fi

# Gitleaks (Secret scanner for git)
install_go_package github.com/gitleaks/gitleaks/v8@latest gitleaks

# Mkcert (Local CA for valid HTTPS certs)
install_go_package filippo.io/mkcert@latest mkcert

# Shellcheck (Shell script analysis tool)
if ! command -v shellcheck &> /dev/null; then
    echo -e "${c}Installing shellcheck...${r}"
    sudo apt install -y shellcheck
else
    echo -e "${c}shellcheck already installed.${r}"
fi

# Age (Modern encryption tool)
install_go_package filippo.io/age/cmd/...@latest age

# Sops (Secrets management tool)
install_go_package github.com/getsops/sops/v3/cmd/sops@latest sops

# Neovim (Modern terminal editor)
if ! command -v nvim &> /dev/null; then
    echo -e "${c}Installing neovim...${r}"
    sudo apt install -y neovim
else
    echo -e "${c}neovim already installed.${r}"
fi

# --- 2026 APPS PART III ---

# Topgrade (Upgrade Everything)
install_cargo_crate topgrade

# Hexyl (Command-line Hex Viewer)
install_cargo_crate hexyl

# Pastel (Command-line Color Tool)
install_cargo_crate pastel

# Zizmor (Static analysis tool for GitHub Actions)
install_cargo_crate zizmor

# Taplo (TOML toolkit)
install_cargo_crate taplo-cli taplo

# Yamlfmt (YAML formatter)
install_go_package github.com/google/yamlfmt/cmd/yamlfmt@latest yamlfmt

# Trzsz (Simple file transfer tool)
install_go_package github.com/trzsz/trzsz-go/cmd/...@latest trzsz

# Csvlens (CSV File Viewer)
install_cargo_crate csvlens

# Qsv (High-performance CSV Data-Wrangling Toolkit)
install_cargo_crate qsv

# --- FUTURE TOOLS 2026 ---

# Gron (Make JSON greppable)
install_go_package github.com/tomnomnom/gron@latest gron

# Typos (Source code spell checker)
install_cargo_crate typos-cli typos

# Ripgrep All (Search in PDFs, E-books, Office documents, zip, tar.gz)
install_cargo_crate ripgrep_all rga

# Git-absorb (Automatically absorb git commit changes)
install_cargo_crate git-absorb

# Cocogitto (A conventional commits toolkit)
install_cargo_crate cocogitto cog

# Bore-cli (Localhost tunneling tool)
install_cargo_crate bore-cli bore

# Macchina (System information fetcher)
install_cargo_crate macchina

# JQL (JSON Query Language CLI)
install_cargo_crate jql

# Pomsky (Portable modern regular expression language)
install_cargo_crate pomsky-bin pomsky

# Fend (Arbitrary-precision unit-aware calculator)
install_cargo_crate fend

# Xc (Markdown defined task runner)
install_go_package github.com/joerdav/xc/cmd/xc@latest xc

# Gtt (Google Translate TUI)
install_go_package github.com/eeeXun/gtt@latest gtt

# Go-task (Modern Make alternative)
install_go_package github.com/go-task/task/v3/cmd/task@latest task

# Sops (Secrets Management) - explicitly add if missing
install_go_package github.com/getsops/sops/v3/cmd/sops@latest sops

# --- 2026 CUTTING EDGE APPS ---

# Numbat (High precision scientific calculator)
install_cargo_crate numbat-cli numbat

# Scc (Sloc, Cloc and Code - Fast accurate code counter)
install_go_package github.com/boyter/scc/v3@latest scc

# Gping (Ping, but with a graph)
install_cargo_crate gping

# Igrep (Interactive Grep)
install_cargo_crate igrep

# Ruplacer (Find and Replace)
install_cargo_crate ruplacer

# Silicon (Code Image Generator)
install_cargo_crate silicon

# Rm-improved (Safe rm)
install_cargo_crate rm-improved rip

# Tgpt (Terminal ChatGPT)
install_go_package github.com/aandrew-me/tgpt/v2@latest tgpt

# Doggo (Command-line DNS Client)
install_go_package github.com/mr-karan/doggo/cmd/doggo@latest doggo

# Harlequin (SQL IDE for terminal)
if ! command -v harlequin &> /dev/null; then
    echo -e "${c}Installing harlequin...${r}"
    pip3 install harlequin --break-system-packages 2>/dev/null || pip3 install harlequin
else
    echo -e "${c}harlequin already installed.${r}"
fi

# Gitingest (Replace git clone with AI friendly prompt)
if ! command -v gitingest &> /dev/null; then
    echo -e "${c}Installing gitingest...${r}"
    pip3 install gitingest --break-system-packages 2>/dev/null || pip3 install gitingest
else
    echo -e "${c}gitingest already installed.${r}"
fi

# Repomix (Pack repository into AI prompt)
if ! command -v repomix &> /dev/null; then
    echo -e "${c}Installing repomix...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g repomix
    else
        echo -e "${c}npm not found, skipping repomix installation.${r}"
    fi
else
    echo -e "${c}repomix already installed.${r}"
fi

# Tenv (OpenTofu/Terraform version manager)
install_go_package github.com/tofuutils/tenv/v3@latest tenv

# Plandex (AI coding engine)
if ! command -v plandex &> /dev/null; then
    echo -e "${c}Installing plandex...${r}"
    curl -sL https://plandex.ai/install.sh | bash
else
    echo -e "${c}plandex already installed.${r}"
fi

# --- 2026 EXPERIMENTAL APPS ---

# Dotenvx (Better dotenv)
if ! command -v dotenvx &> /dev/null; then
    echo -e "${c}Installing dotenvx...${r}"
    { curl -fsS https://dotenvx.sh/ -o /tmp/dotenvx_install.sh && sh /tmp/dotenvx_install.sh; }
else
    echo -e "${c}dotenvx already installed.${r}"
fi

# Zrok (Ngrok alternative)
if ! command -v zrok &> /dev/null; then
    echo -e "${c}Installing zrok...${r}"
    { curl -sSL https://raw.githubusercontent.com/openziti/zrok/main/install/setup.sh -o /tmp/zrok_install.sh && sudo bash /tmp/zrok_install.sh; }
else
    echo -e "${c}zrok already installed.${r}"
fi

# Git-sim (Visually simulate Git operations)
if ! command -v git-sim &> /dev/null; then
    echo -e "${c}Installing git-sim...${r}"
    pip3 install git-sim --break-system-packages 2>/dev/null || pip3 install git-sim
else
    echo -e "${c}git-sim already installed.${r}"
fi

# Charm (The Charm Tool)
install_go_package github.com/charmbracelet/charm@latest charm

# Shell-GPT (AI in terminal)
if ! command -v sgpt &> /dev/null; then
    echo -e "${c}Installing shell-gpt...${r}"
    pip3 install shell-gpt --break-system-packages 2>/dev/null || pip3 install shell-gpt
else
    echo -e "${c}shell-gpt already installed.${r}"
fi

# Miller (Data processing)
install_go_package github.com/johnkerl/miller/cmd/mlr@latest mlr

# USQL (Universal SQL Client)
install_go_package github.com/xo/usql@latest usql

# Joshuto (Terminal file manager)
install_cargo_crate joshuto

# Xplr (TUI file explorer)
install_cargo_crate xplr

# Circumflex (Hacker News in terminal)
install_go_package github.com/bensadeh/circumflex@latest circumflex

# Kubecolor (Colorized kubectl)
install_go_package github.com/kubecolor/kubecolor@latest kubecolor

# Httpstat (curl statistics)
if ! command -v httpstat &> /dev/null; then
    echo -e "${c}Installing httpstat...${r}"
    pip3 install httpstat --break-system-packages 2>/dev/null || pip3 install httpstat
else
    echo -e "${c}httpstat already installed.${r}"
fi

# Chafa (Terminal graphics)
if ! command -v chafa &> /dev/null; then
    echo -e "${c}Installing chafa...${r}"
    sudo apt install -y chafa
else
    echo -e "${c}chafa already installed.${r}"
fi

# Lsd (Modern ls replacement)
install_cargo_crate lsd

# Dprint (Code formatting platform)
install_cargo_crate dprint

# --- BRAND NEW 2026 APPS ---

# Skate (Personal key-value store)
install_go_package github.com/charmbracelet/skate@latest skate

# Melt (Backup and restore ed25519 SSH keys with seed words)
install_go_package github.com/charmbracelet/melt/cmd/melt@latest melt

# Krew (kubectl plugin manager)
install_go_package sigs.k8s.io/krew/cmd/krew@latest krew

# Kubectx and Kubens (Faster way to switch between clusters and namespaces in kubectl)
install_go_package github.com/ahmetb/kubectx/cmd/kubectx@latest kubectx
install_go_package github.com/ahmetb/kubectx/cmd/kubens@latest kubens

# Walk (Terminal Navigator)
install_go_package github.com/antonmedv/walk@latest walk

# Tre (Modern tree command)
install_cargo_crate tre-command tre

# Termshark (Terminal UI for Wireshark/tshark)
install_go_package github.com/gcla/termshark/v2/cmd/termshark@latest termshark

# Actionlint (GitHub Actions Linter)
install_go_package github.com/rhysd/actionlint/cmd/actionlint@latest actionlint

# Popeye (Kubernetes cluster sanitizer)
install_go_package github.com/derailed/popeye@latest popeye

# Walk (Terminal Navigator)
install_go_package github.com/antonmedv/walk@latest walk

# Tre (Modern tree command)
install_cargo_crate tre-command tre

# Termshark (Terminal UI for Wireshark/tshark)
install_go_package github.com/gcla/termshark/v2/cmd/termshark@latest termshark

# Yazi (Duck file manager)
install_cargo_crate yazi-fm yazi
install_cargo_crate yazi-cli ya

# K8sGPT (AI for Kubernetes)
if ! command -v k8sgpt &> /dev/null; then
    echo -e "${c}Installing k8sgpt...${r}"
    sudo eget k8sgpt-ai/k8sgpt --asset "Linux_x86_64.tar.gz" --file k8sgpt --to /usr/local/bin/k8sgpt
else
    echo -e "${c}k8sgpt already installed.${r}"
fi

# Git-Town (High-level CLI for Git)
install_go_package github.com/git-town/git-town/v16@latest git-town

# Dbmate (Database migration tool)
install_go_package github.com/amacneil/dbmate/v2@latest dbmate

# sqlc (Compile SQL to type-safe code)
install_go_package github.com/sqlc-dev/sqlc/cmd/sqlc@latest sqlc

# shfmt (Shell parser, formatter, and interpreter)
install_go_package mvdan.cc/sh/v3/cmd/shfmt@latest shfmt

# Lazynpm (NPM TUI)
install_go_package github.com/jesseduffield/lazynpm@latest lazynpm

# Devbox (Portable Developer Environments)
if ! command -v devbox &> /dev/null; then
    echo -e "${c}Installing devbox...${r}"
    curl -fsSL https://get.jetpack.io/devbox | bash
else
    echo -e "${c}devbox already installed.${r}"
fi

# Pnpm (Fast, disk space efficient package manager)
if ! command -v pnpm &> /dev/null; then
    echo -e "${c}Installing pnpm...${r}"
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    echo -e "${c}pnpm already installed.${r}"
fi

# FNM (Fast Node Manager)
if ! command -v fnm &> /dev/null; then
    echo -e "${c}Installing fnm...${r}"
    curl -fsSL https://fnm.vercel.app/install | bash
else
    echo -e "${c}fnm already installed.${r}"
fi

# --- NEW 2026 APPS ---

# Miniserve (Fast local file server)
install_cargo_crate miniserve

# Viu (Terminal image viewer)
install_cargo_crate viu

# Wthrr (Weather crab)
install_cargo_crate wthrr-the-weathercrab wthrr

# Dura (Auto-backup without committing)
install_cargo_crate dura

# Klog (Time tracker)
install_go_package github.com/jotaen/klog/v2/cmd/klog@latest klog

# Peco (Interactive filtering tool)
install_go_package github.com/peco/peco/cmd/peco@latest peco

# Newsboat (RSS reader)
if ! command -v newsboat &> /dev/null; then
    echo -e "${c}Installing newsboat...${r}"
    sudo apt install -y newsboat
else
    echo -e "${c}newsboat already installed.${r}"
fi

# --- CHARMBRACELET EXTRAS ---

# Skate (Personal Key Value Store)
install_go_package github.com/charmbracelet/skate@latest skate

# Melt (SSH key backup and restore)
install_go_package github.com/charmbracelet/melt@latest melt

# --- KUBERNETES EXTRAS ---

# Helm (The Kubernetes Package Manager)
if ! command -v helm &> /dev/null; then
    echo -e "${c}Installing Helm...${r}"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
else
    echo -e "${c}Helm already installed.${r}"
fi

# K3d (Lightweight Kubernetes in Docker)
if ! command -v k3d &> /dev/null; then
    echo -e "${c}Installing k3d...${r}"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo -e "${c}k3d already installed.${r}"
fi

# Kustomize (Kubernetes native configuration management)
if ! command -v kustomize &> /dev/null; then
    echo -e "${c}Installing Kustomize...${r}"
    (
        cd "$(mktemp -d)"
        curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
        sudo mv kustomize /usr/local/bin/
    )
else
    echo -e "${c}Kustomize already installed.${r}"
fi

# Krew (Kubectl plugin manager)
if ! command -v kubectl-krew &> /dev/null; then
    echo -e "${c}Installing Krew...${r}"
    (
      set -x; cd "$(mktemp -d)" &&
      OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
      local arch
      arch="$(uname -m)"
      case "$arch" in
        x86_64) ARCH="amd64" ;;
        aarch64 | arm64) ARCH="arm64" ;;
        arm*) ARCH="arm" ;;
        *)
          echo "Arquitetura não suportada para o Krew: $arch" >&2
          exit 1
          ;;
      esac
      KREW="krew-${OS}_${ARCH}" &&
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
      tar zxf "${KREW}.tar.gz" &&
      ./"${KREW}" install krew
    )
else
    echo -e "${c}Krew already installed.${r}"
fi

# Kubectx and Kubens (Kubernetes context switching)
install_go_package github.com/ahmetb/kubectx/cmd/kubectx@latest kubectx
install_go_package github.com/ahmetb/kubectx/cmd/kubens@latest kubens

# --- GITHUB EXTRAS ---

# gh-dash (GitHub CLI dashboard)
if command -v gh &> /dev/null; then
    if ! gh extension list | grep -q "^dlvhdr/gh-dash\s"; then
        echo -e "${c}Installing gh-dash extension...${r}"
        gh extension install dlvhdr/gh-dash
    else
        echo -e "${c}gh-dash already installed.${r}"
    fi
else
    echo -e "${c}gh not found, skipping gh-dash extension installation.${r}"
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

# --- CLOUD NATIVE & SYSTEM TOOLS ---

# Kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${c}Installing kubectl...${r}"
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
else
    echo -e "${c}kubectl already installed.${r}"
fi

# Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    echo -e "${c}Installing Google Cloud CLI...${r}"
    sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
    sudo mkdir -p /etc/apt/keyrings
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update
    sudo apt-get install -y google-cloud-cli
else
    echo -e "${c}gcloud already installed.${r}"
fi

# Ngrok (Unified Application Delivery Platform)
if ! command -v ngrok &> /dev/null; then
    echo -e "${c}Installing ngrok...${r}"
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo gpg --dearmor -o /usr/share/keyrings/ngrok.gpg
    echo "deb [signed-by=/usr/share/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update
    sudo apt install -y ngrok
else
    echo -e "${c}ngrok already installed.${r}"
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

# --- NEW 2026 APPS ---

# Ctop (Top-like interface for container metrics)
install_go_package github.com/bcicen/ctop@latest ctop

# Httpie (Modern, user-friendly command-line HTTP client)
if ! command -v http &> /dev/null; then
    echo -e "${c}Installing httpie...${r}"
    pip3 install httpie --break-system-packages 2>/dev/null || pip3 install httpie
else
    echo -e "${c}httpie already installed.${r}"
fi

# Croc (Easily and securely send things from one computer to another)
install_go_package github.com/schollz/croc/v10@latest croc

# Dufs (A distinctive utility file server)
install_cargo_crate dufs

# Cheat (Create and view interactive cheatsheets on the command-line)
install_go_package github.com/cheat/cheat/cmd/cheat@latest cheat

# Yt-dlp (Feature-rich command-line audio/video downloader)
if ! command -v yt-dlp &> /dev/null; then
    echo -e "${c}Installing yt-dlp...${r}"
    if command -v uv &> /dev/null; then
        uv tool install yt-dlp
    elif command -v pip3 &> /dev/null; then
        pip3 install yt-dlp --break-system-packages 2>/dev/null || pip3 install yt-dlp
    else
        echo -e "${c}Neither uv nor pip3 found, skipping yt-dlp installation.${r}"
    fi
else
    echo -e "${c}yt-dlp already installed.${r}"
fi

# Porsmo (Pomodoro CLI)
install_cargo_crate porsmo

# Rustscan (Faster Nmap Scanning)
install_cargo_crate rustscan

# Diskonaut (Terminal disk space navigator)
install_cargo_crate diskonaut

# --- BRAND NEW 2026 APPS PART II ---

# Xplr (TUI file explorer)
install_cargo_crate xplr

# Systeroid (Kernel parameter manager)
install_cargo_crate systeroid

# Systemctl-tui (Systemd TUI)
install_cargo_crate systemctl-tui

# Bruno CLI (API testing)
if ! command -v bru &> /dev/null; then
    echo -e "${c}Installing bruno-cli...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g @usebruno/cli
    else
        echo -e "${c}npm not found, skipping bruno-cli installation.${r}"
    fi
else
    echo -e "${c}bruno-cli already installed.${r}"
fi

# Mani (Multi-repository management)
install_go_package github.com/alajmo/mani@latest mani

# Xcp (Extended cp)
install_cargo_crate xcp

# Dysk (Linux disks info)
install_cargo_crate dysk

# So (StackOverflow in terminal)
install_cargo_crate so

# Inlyne (GPU powered markdown viewer)
install_cargo_crate inlyne

# Ncspot (Cross-platform Spotify client)
install_cargo_crate ncspot

# --- EXTRA 2026 APPS ---

# Sniffnet (Application to comfortably monitor your network traffic)
install_cargo_crate sniffnet

# JC (Converts output of popular command-line tools and file-types to JSON)
if ! command -v jc &> /dev/null; then
    echo -e "${c}Installing jc...${r}"
    sudo apt install -y jc
else
    echo -e "${c}jc already installed.${r}"
fi

# Hwatch (A modern alternative to the watch command)
install_cargo_crate hwatch

# --- HYPER-MODERN 2026 APPS ---

# Jujutsu (jj - Git alternative)
install_cargo_crate jj-cli jj

# Trivy (Container security scanner)
if ! command -v trivy &> /dev/null; then
    echo -e "${c}Installing trivy...${r}"
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/trivy.gpg
    echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install -y trivy
else
    echo -e "${c}trivy already installed.${r}"
fi

# Earthly (Build automation)
if ! command -v earthly &> /dev/null; then
    echo -e "${c}Installing earthly...${r}"
    sudo wget -q https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly
    sudo chmod +x /usr/local/bin/earthly
else
    echo -e "${c}earthly already installed.${r}"
fi

# Kind (Local Kubernetes)
install_go_package sigs.k8s.io/kind@latest kind

# hck (Fast cut replacement)
install_cargo_crate hck

# Cloudflared (Localhost tunneling)
if ! command -v cloudflared &> /dev/null; then
    echo -e "${c}Installing cloudflared...${r}"
    sudo wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
    sudo chmod +x /usr/local/bin/cloudflared
else
    echo -e "${c}cloudflared already installed.${r}"
fi

# --- NEWEST 2026 APPS ---

# jo (JSON output utility)
if ! command -v jo &> /dev/null; then
    echo -e "${c}Installing jo...${r}"
    sudo apt install -y jo
else
    echo -e "${c}jo already installed.${r}"
fi

# k6 (Modern load testing tool)
if ! command -v k6 &> /dev/null; then
    echo -e "${c}Installing k6...${r}"
    install_go_package go.k6.io/k6@latest k6
else
    echo -e "${c}k6 already installed.${r}"
fi

# dolt (Git for data)
if ! command -v dolt &> /dev/null; then
    echo -e "${c}Installing dolt...${r}"
    curl -sL https://github.com/dolthub/dolt/releases/latest/download/install.sh -o /tmp/dolt_install.sh && sudo bash /tmp/dolt_install.sh && rm /tmp/dolt_install.sh
else
    echo -e "${c}dolt already installed.${r}"
fi

# turso (Edge database CLI)
if ! command -v turso &> /dev/null; then
    echo -e "${c}Installing turso...${r}"
    curl -sL https://get.turso.tech/install.sh | bash
else
    echo -e "${c}turso already installed.${r}"
fi

# flyctl (Fly.io CLI)
if ! command -v flyctl &> /dev/null; then
    echo -e "${c}Installing flyctl...${r}"
    curl -L https://fly.io/install.sh | sh
else
    echo -e "${c}flyctl already installed.${r}"
fi

# Kalker (Math calculator)
install_cargo_crate kalker

# Ugrep (Ultra fast grep)
if ! command -v ugrep &> /dev/null; then
    echo -e "${c}Installing ugrep...${r}"
    sudo apt install -y ugrep
else
    echo -e "${c}ugrep already installed.${r}"
fi

# Termscp (Terminal file transfer)
install_cargo_crate termscp

# Lychee (Fast, async, stream-based link checker)
install_cargo_crate lychee

# Bluetuith (TUI bluetooth manager)
install_go_package github.com/darkhz/bluetuith@latest bluetuith

# Czg (Interactive Commitizen CLI)
if ! command -v czg &> /dev/null; then
    echo -e "${c}Installing czg...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g czg
    else
        echo -e "${c}npm not found, skipping czg installation.${r}"
    fi
else
    echo -e "${c}czg already installed.${r}"
fi

# Bat-extras (Bash scripts that integrate bat with various command line tools)
if ! command -v batman &> /dev/null; then
    echo -e "${c}Installing bat-extras...${r}"
    curl -fsSL https://raw.githubusercontent.com/eth-p/bat-extras/master/build.sh | sudo bash -s -- --install
else
    echo -e "${c}bat-extras already installed.${r}"
fi

echo -e "${c}CLI Tools installed! Ensure ~/.local/bin, ~/.cargo/bin and ~/go/bin are in your PATH.${r}"
# --- BEYOND 2026 APPS ---

# Aider-chat (AI pair programming)
if ! command -v aider &> /dev/null; then
    echo -e "${c}Installing aider-chat...${r}"
    if command -v pipx &> /dev/null; then
        pipx install aider-chat
    else
        pip3 install aider-chat --break-system-packages 2>/dev/null || pip3 install aider-chat
    fi
else
    echo -e "${c}aider-chat already installed.${r}"
fi

# Repomix (Pack repository into AI prompt)
if ! command -v repomix &> /dev/null; then
    echo -e "${c}Installing repomix...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g repomix
    else
        echo -e "${c}npm not found, skipping repomix installation.${r}"
    fi
else
    echo -e "${c}repomix already installed.${r}"
fi

# Gitingest (Replace git clone with AI friendly prompt)
if ! command -v gitingest &> /dev/null; then
    echo -e "${c}Installing gitingest...${r}"
    pip3 install gitingest --break-system-packages 2>/dev/null || pip3 install gitingest
else
    echo -e "${c}gitingest already installed.${r}"
fi

# Harlequin (SQL IDE for terminal)
if ! command -v harlequin &> /dev/null; then
    echo -e "${c}Installing harlequin...${r}"
    pip3 install harlequin --break-system-packages 2>/dev/null || pip3 install harlequin
else
    echo -e "${c}harlequin already installed.${r}"
fi

# Slumber (Terminal HTTP Client)
install_cargo_crate slumber

# Plandex (AI coding engine)
if ! command -v plandex &> /dev/null; then
    echo -e "${c}Installing plandex...${r}"
    curl -sL https://plandex.ai/install.sh | sh
else
    echo -e "${c}plandex already installed.${r}"
fi

# --- THE VERY EDGE OF 2026 APPS ---

# ChatGPT CLI
if ! command -v chatgpt &> /dev/null; then
    echo -e "${c}Installing chatgpt-cli...${r}"
    if command -v npm &> /dev/null; then
        sudo npm install -g chatgpt-cli
    else
        echo -e "${c}npm not found, skipping chatgpt-cli installation.${r}"
    fi
else
    echo -e "${c}chatgpt-cli already installed.${r}"
fi

# Tldr (Fast tldr client in C)
if ! command -v tldr &> /dev/null; then
    echo -e "${c}Installing tldr...${r}"
    sudo apt install -y tldr
else
    echo -e "${c}tldr already installed.${r}"
fi

# Httpstat (Curl statistics made simple)
if ! command -v httpstat &> /dev/null; then
    echo -e "${c}Installing httpstat...${r}"
    pip3 install httpstat --break-system-packages 2>/dev/null || pip3 install httpstat
else
    echo -e "${c}httpstat already installed.${r}"
fi

# Tt (Typing test in terminal)
install_go_package github.com/lemnos/tt@latest tt

# Px (ps and top for Human Beings)
if ! command -v px &> /dev/null; then
    echo -e "${c}Installing px...${r}"
    pip3 install px-command --break-system-packages 2>/dev/null || pip3 install px-command
else
    echo -e "${c}px already installed.${r}"
fi
