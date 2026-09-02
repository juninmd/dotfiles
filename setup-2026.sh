#!/usr/bin/env bash
set -euo pipefail

START_TIME=$(date +%s)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
PROFILE=""

# Ensure gum is available for an interactive experience
TMP_GUM_DIR=""
if ! command -v gum &> /dev/null; then
    echo "Baixando 'gum' temporariamente para uma melhor interface..."
    TMP_GUM_DIR=$(mktemp -d)
    wget -qO "$TMP_GUM_DIR/gum.tar.gz" https://github.com/charmbracelet/gum/releases/download/v0.14.3/gum_0.14.3_Linux_x86_64.tar.gz
    # The tarball directly contains the 'gum' binary
    tar -xzf "$TMP_GUM_DIR/gum.tar.gz" -C "$TMP_GUM_DIR" --strip-components=1 gum_0.14.3_Linux_x86_64/gum
    chmod +x "$TMP_GUM_DIR/gum"
    rm "$TMP_GUM_DIR/gum.tar.gz"
    GUM="$TMP_GUM_DIR/gum"
else
    GUM="gum"
fi

log() {
  if command -v "$GUM" &> /dev/null; then
    "$GUM" style --foreground "#ff7edb" "[$($GUM style --foreground "#36f9f6" "2026-setup")] $*"
  else
    printf '\e[36m[2026-setup]\e[0m %s\n' "$*"
  fi
}

usage() {
  cat <<USAGE
Uso: ./setup-2026.sh [--dry-run] [--profile minimal|dev|full|ai-dev]

Perfis:
  minimal  -> shell moderna + prompt + editor
  dev      -> minimal + runtime JS + docker + banco
  full     -> dev + ferramentas extras de produtividade
  ai-dev   -> minimal + cursor + zed + warp + ferramentas AI
USAGE
}

run_step() {
  local step="$1"
  shift

  if [[ "$DRY_RUN" == true ]]; then
    log "[dry-run] $step"
    return 0
  fi

  log "$step"
  "$@"
}

SUCCESS_COUNT=0
FAIL_COUNT=0


draw_progress_bar() {
  local current="$1"
  local total="$2"
  local width=40
  local percent=$(( current * 100 / total ))
  local filled=$(( percent * width / 100 ))
  local empty=$(( width - filled ))
  local bar_filled=$(printf "%${filled}s" | tr ' ' '█')
  local bar_empty=$(printf "%${empty}s" | tr ' ' '░')
  if [ "$filled" -eq 0 ]; then bar_filled=""; fi
  if [ "$empty" -eq 0 ]; then bar_empty=""; fi

  if command -v "$GUM" &> /dev/null; then
    # We return the formatted string instead of echoing it, so we can use it inline
    echo -n "$($GUM style --foreground "#ff7edb" "[$($GUM style --foreground "#36f9f6" "${bar_filled}")$($GUM style --foreground "#6272a4" "${bar_empty}")] $($GUM style --foreground "#fede5d" "${percent}%")")"
  else
    echo "[${bar_filled}${bar_empty}] ${percent}%"
  fi
}

run_module() {
  local module="$1"
  local current_idx="$2"
  local total_mods="$3"
  local script="$ROOT_DIR/programas/$module/setup.sh"

  if [[ ! -x "$script" ]]; then
    chmod +x "$script"
  fi

  local progress_prefix="[$current_idx/$total_mods]"

  if [[ "$DRY_RUN" == true ]]; then
    if command -v "$GUM" &> /dev/null; then
      echo "$(draw_progress_bar "$current_idx" "$total_mods")"
    fi
    run_step "$progress_prefix Executando módulo: $module" "$script"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    if command -v "$GUM" &> /dev/null; then
      local bar="$(draw_progress_bar "$current_idx" "$total_mods")"
      if "$GUM" spin --spinner globe --spinner.foreground "#36f9f6" --title "$bar $($GUM style --foreground "#fede5d" "$progress_prefix Instalando:") $($GUM style --foreground "#ff7edb" "$module...")" -- bash -c '"$1" > "/tmp/setup-2026-$2.log" 2>&1' -- "$script" "$module"; then
        echo "$($GUM style --foreground "#72f1b8" "✔") $($GUM style --foreground "#f8f8f2" "$progress_prefix Módulo") $($GUM style --foreground "#fede5d" "$module") $($GUM style --foreground "#f8f8f2" "instalado com sucesso!")"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
      else
        echo "$($GUM style --foreground "#ff7edb" "✖") $($GUM style --foreground "#f8f8f2" "$progress_prefix Erro ao instalar módulo") $($GUM style --foreground "#fede5d" "$module")$($GUM style --foreground "#f8f8f2" ". Verifique os logs.")"
        FAIL_COUNT=$((FAIL_COUNT + 1))
      fi
    else
      if run_step "$progress_prefix Executando módulo: $module" "$script"; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
      else
        FAIL_COUNT=$((FAIL_COUNT + 1))
      fi
    fi
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "Argumento inválido: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  if command -v "$GUM" &> /dev/null; then
    clear
    HEADER=$("$GUM" style \
      --foreground "#ff7edb" --border-foreground "#bd93f9" --border double \
      --align center --width 80 --margin "1 2" --padding "3 5" \
      ' ▂▃▄▅▆▇█▓▒░ NEXUS DOTFILES 2026 ░▒▓█▇▆▅▄▃▂ ' \
      '' \
      '███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗' \
      '████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝' \
      '██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗' \
      '██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║' \
      '██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║' \
      '╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝' \
      '██████╗  ██████╗ ██████╗  ██████╗ ' \
      '╚════██╗██╔═████╗╚════██╗██╔════╝ ' \
      ' █████╔╝██║██╔██║ █████╔╝███████╗ ' \
      '██╔═══╝ ████╔╝██║██╔═══╝ ██╔═══██╗' \
      '███████╗╚██████╔╝███████╗╚██████╔╝' \
      '╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ' \
      '' \
      "$($GUM style --foreground "#36f9f6" --bold '⚡ NEXUS 2026: THE ULTIMATE CYBERPUNK EXPERIENCE ⚡')" \
      "$($GUM style --foreground "#72f1b8" 'A Matrix Foi Atualizada. O Futuro é Agora.')")

    INFO=$("$GUM" style \
      --foreground "#36f9f6" --border-foreground "#ff7edb" --border rounded \
      --align left --width 40 --margin "1 2" --padding "3 5" \
      "$($GUM style --foreground "#bd93f9" --bold '🌌 CONECTANDO AO NEXUS 2026')" \
      '' \
      "$($GUM style --foreground "#ff7edb" '🚀 Motor de dobra calibrado...')" \
      "$($GUM style --foreground "#fede5d" '⚡ Injetando neuro-código...')" \
      "$($GUM style --foreground "#72f1b8" '✨ Realidade virtualizada.')" \
      "$($GUM style --foreground "#36f9f6" '🤖 IA de combate ativada.')")

    OS_INFO=$(uname -s)
    ARCH_INFO=$(uname -m)
    USER_INFO=$(whoami)
    HOST_INFO=${HOSTNAME:-$(hostname 2>/dev/null || echo "unknown")}
    SHELL_INFO=$(basename "${SHELL:-/bin/bash}")
    DATE_INFO=$(date '+%Y-%m-%d')
    UPTIME_INFO=$(uptime -p 2>/dev/null || uptime | sed 's/.*up //; s/, [0-9]* user.*//')
    MEM_INFO=$(free -h | awk '/^Mem:/ {print $3 "/" $2}' | tr -d 'i')
    DISK_INFO=$(df -h / | awk 'NR==2 {print $3 "/" $2}' | tr -d 'i')
    SYS_INFO=$("$GUM" style \
      --foreground "#f8f8f2" --border-foreground "#bd93f9" --border double \
      --align left --width 30 --margin "1 2" --padding "2 3" \
      '💻 SYSTEM INFO' \
      '' \
      "👤 User:  $($GUM style --foreground "#fede5d" "$USER_INFO")" \
      "🏠 Host:  $($GUM style --foreground "#bd93f9" "$HOST_INFO")" \
      "🖥️ OS:    $($GUM style --foreground "#ff7edb" "$OS_INFO")" \
      "⚙️ Arch:  $($GUM style --foreground "#36f9f6" "$ARCH_INFO")" \
      "🐚 Shell: $($GUM style --foreground "#fede5d" "$SHELL_INFO")" \
      "📅 Date:  $($GUM style --foreground "#72f1b8" "$DATE_INFO")" \
      "⏱️ Uptime: $($GUM style --foreground "#ff7edb" "$UPTIME_INFO")" \
      "🧠 Mem:   $($GUM style --foreground "#36f9f6" "$MEM_INFO")" \
      "💾 Disk:  $($GUM style --foreground "#bd93f9" "$DISK_INFO")")

    "$GUM" join --vertical --align center "$HEADER" "$("$GUM" join --horizontal --align center "$INFO" "$SYS_INFO")"
    echo ""

    "$GUM" style \
      --foreground "#fede5d" --bold \
      --border double --border-foreground "#ff7edb" \
      --padding "1 2" --margin "1 0" --align center --width 100 \
      "🌐 Iniciando Protocolo de Setup 2026 🌐" \
      "Selecione o perfil de instalação para turbinar sua máquina:"
    echo ""
    PROFILE_CHOICE=$("$GUM" choose \
      --height=20 \
      --cursor="🚀 " \
      --header="Escolha o seu nível de poder no Nexus:" \
      --header.foreground="#ff7edb" \
      --header.bold \
      --cursor.foreground="#72f1b8" \
      --cursor.bold \
      --item.foreground="#f8f8f2" \
      --selected.foreground="#36f9f6" \
      --selected.bold \
      "minimal   - 🪶 Shell moderna / prompt limpo / e editor ultrarrápido. (Essencial)." \
      "dev       - 🚀 minimal + Runtimes JS/Python / Docker e BD. (Recomendado para Ninjas)." \
      "full      - 🌌 dev + Apps extras de produtividade (Navegador / Slack / Android)." \
      "ai-dev    - 🤖 minimal + Cursor / Zed / Warp e Apps de AI. (O Futuro Agora).")
    PROFILE=$(echo "$PROFILE_CHOICE" | awk '{print $1}')
  else
    read -rp "Escolha o perfil (minimal, dev, full, ai-dev) [full]: " PROFILE
    PROFILE=${PROFILE:-full}
  fi
fi

case "$PROFILE" in
  minimal)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship vscode sd choose gobang bottom macchina xplr circumflex lsd lazydocker lazygit-tui k9s-cli posting aider)
    ;;
  dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit-tui lazydocker vscode zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aichat duckdb lazysql harlequin)
    ;;
  full)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp lazygit-tui lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s-cli posting superfile aider plandex open-interpreter duckdb harlequin neofetch-alt lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aider-chat trippy onefetch grex bandwhich amber tailspin erdtree dua oxlint difftastic topgrade pastel numbat dufs jj sesh carapace moar vhs gitleaks xc gdu trash-cli yt-dlp glances d2 poetry pnpm fnm gping kondo presenterm hexyl csvlens pomsky bacon wiki-tui ast-grep dive gron viddy wtfutil cointop dasel dust navi delta websocat ouch zenith git-cliff typos fend joshuto sniffnet termscp wthrr miniserve zizmor inlyne so xcp taplo tlrc typst xsv gh act task croc dbmate ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next gptme ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli)
    ;;
  *)
    log "Perfil inválido: $PROFILE"
    usage
    exit 1
    ;;
esac

log "Perfil selecionado: $PROFILE"

# Human-readable descriptions for the modules
declare -A MOD_DESC=(
  ["act"]="🎭 act (Run GitHub Actions Locally)"
  ["actionlint"]="📦 actionlint (Static checker for GitHub Actions workflow files)"
  ["age"]="📦 age (A simple modern and secure file encryption tool)"
  ["aichat"]="💬 aichat (AI Chat)"
  ["aider"]="🤖 Aider-chat (AI pair programming)"
  ["aider-chat"]="🤖 Aider-chat (AI pair programming)"
  ["amber"]="🔍 amber (Search & Replace)"
  ["android"]="📱 Android Studio & SDK (Plataforma Mobile)"
  ["argc"]="🐚 argc (A bash CLI framework)"
  ["argocd"]="🐙 ArgoCD (Declarative GitOps for K8s)"
  ["ast-grep"]="🌳 ast-grep (AST based search replace)"
  ["atac"]="🚀 Atac (Modern API Client TUI)"
  ["atlas"]="📦 atlas (Modern tool for managing database schemas)"
  ["atuin"]="🐢 Atuin (Magical Shell History)"
  ["awscli"]="☁️ AWS CLI (Amazon Web Services CLI)"
  ["bacon"]="🥓 bacon (Background Rust code checker)"
  ["bandwhich"]="📈 bandwhich (Bandwidth Monitor)"
  ["bat"]="🦇 Bat (A cat clone with wings)"
  ["bat-extras"]="🦇 bat-extras (Bash scripts that integrate bat with various command line tools)"
  ["binsider"]="🔍 binsider (Analyze ELF binaries)"
  ["biome"]="🚀 Biome (Fast JS TS toolchain)"
  ["bluetuith"]="🦷 bluetuith (Bluetooth manager TUI)"
  ["bore-cli"]="🚇 bore-cli (Local tunneling)"
  ["bottom"]="📈 bottom (System Monitor)"
  ["boundary"]="🛡️ boundary (Identity-based access management)"
  ["brave"]="🦁 Brave (Navegador focado em privacidade)"
  ["broot"]="🌲 Broot (A new way to see and navigate directory trees)"
  ["bruno"]="🐶 Bruno (API Client open-source e leve)"
  ["bruno-cli"]="🐶 bruno-cli (API Client CLI)"
  ["btop"]="📊 Btop (A monitor of resources)"
  ["bun"]="🥟 Bun JavaScript runtime (Ultrarrápido)"
  ["bw"]="🔐 Bitwarden CLI (Password Manager)"
  ["carapace"]="🐚 carapace (Multi-shell Completer)"
  ["cbonsai"]="🌲 cbonsai (Terminal bonsai tree)"
  ["chafa"]="🎨 chafa (Terminal graphics)"
  ["charm"]="✨ charm (Charmbracelet tool)"
  ["chatbox"]="💬 Chatbox (Copilot for your desktop)"
  ["chatgpt-cli"]="🤖 chatgpt-cli (ChatGPT in terminal)"
  ["cheat"]="📄 cheat (Interactive cheatsheets)"
  ["checkov"]="🛡️ checkov (IaC scanner)"
  ["choose"]="✂️ choose (Human-friendly cut)"
  ["circumflex"]="📰 circumflex (Hacker News in terminal)"
  ["claude-code"]="🤖 Claude Code (AI Assistant CLI da Anthropic)"
  ["cli-tools"]="🧰 Dependências Base 2026 (Rust Go Python build-tools)"
  ["cline"]="🤖 Cline (Autonomous coding agent CLI)"
  ["cloudflared"]="☁️ cloudflared (Cloudflare Tunnel client)"
  ["cocogitto"]="⚙️ cocogitto (Conventional commits CLI)"
  ["cmatrix"]="💻 cmatrix (Classic Matrix terminal effect)"
  ["code2prompt"]="📝 code2prompt (Convert codebase to LLM prompt)"
  ["cointop"]="🪙 cointop (Crypto tracker)"
  ["common"]="⚙️ Scripts compartilhados e helpers"
  ["consul"]="🌐 Consul (Service Networking)"
  ["cpufetch"]="💻 cpufetch (CPU architecture fetching)"
  ["crane"]="🏗️ crane (Container image interaction)"
  ["croc"]="🐊 croc (Securely send things between computers)"
  ["csvlens"]="📊 csvlens (CSV viewer)"
  ["ctop"]="🐳 ctop (Top-like interface for container metrics)"
  ["curlie"]="🦱 Curlie (curl + httpie)"
  ["cursor"]="🤖 Cursor AI Code Editor (Futuro do código)"
  ["czg"]="📝 czg (Commitizen CLI)"
  ["d2"]="📊 d2 (Declarative Diagramming)"
  ["dagger"]="🗡️ Dagger (Programmable CI CD engine)"
  ["dapr"]="📦 Dapr CLI (Modern tool for building distributed applications)"
  ["dasel"]="🔍 dasel (Query update data formats)"
  ["daytona"]="🌅 Daytona (Self-hosted development environment manager)"
  ["dbeaver"]="🐘 DBeaver (Cliente universal para bancos de dados)"
  ["dbmate"]="🗃️ dbmate (Database migration tool)"
  ["delta"]="🔀 delta (A syntax-highlighting pager for git diff and grep output)"
  ["deno"]="🦕 Deno (Modern JS TS runtime)"
  ["devbox"]="📦 Devbox (Portable Developer Environments)"
  ["devenv"]="⚙️ Devenv (Declarative Developer Environments)"
  ["devpod"]="🚀 DevPod (Codespaces but open-source)"
  ["devtoy"]="🧰 devtoy (A Swiss Army knife for developers)"
  ["difftastic"]="🧬 difftastic (Structural diff)"
  ["direnv"]="🔧 direnv (Environment variable manager)"
  ["discord"]="🎮 Discord (Comunicação de voz e texto)"
  ["diskonaut"]="💾 diskonaut (Terminal disk space navigator)"
  ["distrobox"]="📦 Distrobox (Run any linux distro in terminal)"
  ["dive"]="🐳 dive (Docker image explorer)"
  ["docker"]="🐳 Docker Engine (Contêineres)"
  ["doggo"]="🐶 Doggo (Modern DNS Client)"
  ["dolt"]="🐬 dolt (Git for data)"
  ["doppler"]="🔐 Doppler (SecretOps Platform)"
  ["dotenv-linter"]="✅ dotenv-linter (Linter for .env files)"
  ["dotenvx"]="🔑 dotenvx (Manage .env files)"
  ["dprint"]="🖋️ dprint (Pluggable formatting platform)"
  ["dsq"]="🗃️ dsq (SQL for JSON CSV etc.)"
  ["dua"]="💽 dua (Disk Usage Analyzer)"
  ["dua-cli"]="📊 dua-cli (Disk usage analyzer)"
  ["duckdb"]="🦆 DuckDB (In-process SQL OLAP DBMS)"
  ["duf"]="🖥️ duf (Disk usage free utility)"
  ["dufs"]="📁 dufs (Utility file server)"
  ["dura"]="💾 dura (Git background backup)"
  ["dust"]="🌪️ dust (A more intuitive version of du in rust)"
  ["dysk"]="💽 dysk (Linux disk info)"
  ["earthly"]="🌍 earthly (Build automation)"
  ["eget"]="📥 eget (Download pre-built binaries)"
  ["elixir"]="💧 Elixir (Dynamic functional language for building scalable and maintainable applications)"
  ["erdtree"]="🌳 erdtree (File-tree Visualizer)"
  ["evans"]="grpc evans (gRPC client)"
  ["eza"]="🌟 Eza (A modern maintained replacement for ls)"
  ["fabric"]="🤖 fabric (AI CLI framework)"
  ["neofetch-alt"]="⚡ neofetch-alt (Modern System Info)"
  ["fd-find"]="📂 fd (A simple fast and user-friendly alternative to find)"
  ["fastfetch"]="⚡ fastfetch (Modern System Info)"
  ["fend"]="🧮 fend (Arbitrary-precision unit-aware calculator)"
  ["ffuf"]="🔍 ffuf (Fast web fuzzer written in Go)"
  ["firefox"]="🦊 Navegador Firefox (Otimizado)"
  ["flox"]="❄️ Flox (Developer environments for everyone)"
  ["flyctl"]="✈️ flyctl (Fly.io CLI)"
  ["fnm"]="🐢 fnm (Fast Node Manager)"
  ["fq"]="🔍 fq (jq for binary formats)"
  ["freeze"]="📸 freeze (Code screenshots)"
  ["fx"]="👾 JSON fx (Terminal JSON viewer)"
  ["fzf"]="🔍 Fzf (A command-line fuzzy finder)"
  ["gcloud"]="☁️ gcloud (Google Cloud CLI)"
  ["gdu"]="📊 gdu (Disk usage analyzer)"
  ["genact"]="🎭 genact (Fake activity generator)"
  ["gh"]="🐙 gh (GitHub CLI)"
  ["gh-dash"]="🐙 gh-dash (GitHub CLI dashboard)"
  ["ghostty"]="👻 Ghostty (Emulador de Terminal Ultrarrápido)"
  ["ghq"]="📂 ghq (Manage remote repository clones)"
  ["git-absorb"]="🧽 git-absorb (Automatic git commit fixing)"
  ["git-cliff"]="⛰️ git-cliff (Changelog Generator)"
  ["git-filter-repo"]="🧹 git-filter-repo (Rewrite git history)"
  ["git-next"]="🐙 git-next (Trunk-based development manager)"
  ["git-sim"]="🔮 git-sim (Visually simulate Git operations)"
  ["git-town"]="🏙️ git-town (High-level Git workflow support)"
  ["gitingest"]="🧠 Gitingest (Git to AI prompt)"
  ["gitleaks"]="🔐 gitleaks (Secret scanner for git)"
  ["gitui"]="🐙 GitUI (Blazing Fast Git TUI)"
  ["glab"]="🦊 glab (GitLab CLI)"
  ["glances"]="👀 glances (System monitor)"
  ["gleam"]="✨ Gleam (Type safe programming language)"
  ["glow"]="🌟 Glow (Markdown Renderer)"
  ["gobang"]="🗃️ gobang (Cross-platform Database Client TUI)"
  ["gojq"]="🔍 gojq (Pure Go implementation of jq)"
  ["gping"]="🏓 gping (Ping but with a graph)"
  ["grex"]="🧠 grex (Regex Generator)"
  ["gron"]="🔧 gron (Make JSON greppable)"
  ["grpcurl"]="📡 grpcurl (curl for gRPC servers)"
  ["grype"]="🔒 grype (Vulnerability scanner for images)"
  ["gtt"]="🌐 gtt (Google Translate TUI)"
  ["gum"]="🍬 gum (Glamorous shell scripts)"
  ["aqua"]="💧 aqua (Declarative CLI Version Manager)"
  ["kcl"]="📝 kcl (KCL Configuration Language)"
  ["devspace"]="🚀 devspace (Cloud Native Dev Environment)"
  ["lazygit"]="🐙 lazygit (Simple terminal UI for git commands)"
  ["lens"]="👁️ lens (Kubernetes IDE)"
  ["marimo"]="📓 marimo (Reactive Python Notebooks)"
  ["bito"]="🤖 bito (AI CLI tool)"
  ["gorilla-cli"]="🦍 gorilla-cli (LLMs for CLI)"
  ["hadolint"]="🐳 hadolint (Dockerfile linter)"
  ["harlequin"]="🎩 Harlequin (SQL IDE for terminal)"
  ["hck"]="📦 hck (A sharp cut(1) clone)"
  ["helix"]="🧬 Helix (Post-modern text editor)"
  ["helm"]="⎈ helm (Kubernetes package manager)"
  ["heroku"]="☁️ Heroku CLI (Manage Heroku apps)"
  ["hexyl"]="🔢 hexyl (Hex viewer)"
  ["howdoi"]="❓ howdoi (Instant coding answers)"
  ["htop"]="📊 htop (Interactive process viewer)"
  ["htmlq"]="📄 htmlq (jq for HTML)"
  ["httpie"]="🌐 httpie (Modern HTTP client)"
  ["httpstat"]="📊 httpstat (curl statistics visualization)"
  ["httpx"]="⚡ httpx (Fast and multi-purpose HTTP toolkit)"
  ["hurl"]="🎯 hurl (Run HTTP requests defined in a simple plain text format)"
  ["hwatch"]="👀 hwatch (Modern alternative to watch)"
  ["hyperfine"]="⏱️ Hyperfine (A command-line benchmarking tool)"
  ["igrep"]="🔎 igrep (Interactive Grep)"
  ["infisical"]="🔐 Infisical (Open Source Secret Management)"
  ["infracost"]="💰 infracost (Cloud cost estimates for Terraform)"
  ["inlyne"]="🖥️ inlyne (GPU powered markdown viewer)"
  ["inshellisense"]="💡 Inshellisense (IDE style autocomplete for shells)"
  ["jan"]="🤖 Jan (Local AI alternative to ChatGPT)"
  ["jaq"]="🔍 jaq (A jq clone focused on correctness speed and simplicity)"
  ["jc"]="🔧 jc (Convert CLI output to JSON)"
  ["jira-cli"]="🎫 jira-cli (Jira command line)"
  ["jj"]="🐙 jj (Git alternative)"
  ["jless"]="🔍 Jless (JSON Viewer)"
  ["jnv"]="🔍 jnv (Interactive jq frontend)"
  ["jo"]="🔧 jo (JSON output utility)"
  ["joshuto"]="📁 joshuto (Terminal file manager)"
  ["jq"]="🔍 jq (Command-line JSON processor)"
  ["jql"]="🔍 jql (JSON query language CLI tool)"
  ["jqp"]="🔍 jqp (TUI playground for jq)"
  ["jujutsu"]="🥋 jujutsu (A Git-compatible VCS)"
  ["just"]="🤖 Just (Command Runner)"
  ["k3d"]="🐳 k3d (Lightweight Kubernetes in Docker)"
  ["k3s"]="☸️ k3s (Lightweight Kubernetes)"
  ["k6"]="🚀 k6 (Modern load testing tool)"
  ["k8sgpt"]="☸️ k8sgpt (AI for Kubernetes)"
  ["k9s-cli"]="🐶 k9s-cli (Kubernetes CLI TUI)"
  ["kaskade"]="🌊 kaskade (Kafka TUI)"
  ["kalker"]="🧮 kalker (Math calculator)"
  ["kdash"]="☸️ kdash (Kubernetes Dashboard)"
  ["kind"]="🐳 kind (Kubernetes in Docker)"
  ["klog"]="⏱️ klog (Time tracking in plain text)"
  ["kmon"]="🐧 kmon (Linux Kernel Manager and Activity Monitor)"
  ["ko"]="📦 ko (Build and deploy Go applications on Kubernetes)"
  ["kondo"]="🧹 kondo (Clean up software projects)"
  ["krew"]="🔌 krew (Package manager for kubectl plugins)"
  ["kubecolor"]="🎨 kubecolor (Colorize your kubectl output)"
  ["kubectl"]="⎈ kubectl (Kubernetes command-line tool)"
  ["kubectx"]="⎈ kubectx (Switch between Kubernetes contexts)"
  ["kubens"]="📦 kubens (Kubernetes context switching)"
  ["kustomize"]="🛠️ kustomize (Customization of kubernetes YAML configurations)"
  ["lazydocker"]="🐳 LazyDocker TUI (Contêineres com Estilo)"
  ["lazygit-tui"]="🐙 lazygit-tui TUI (Git feito certo)"
  ["lazynpm"]="📦 Lazynpm (NPM TUI)"
  ["lazysql"]="🦥 Lazysql (SQL Client TUI)"
  ["lefthook"]="🪝 lefthook (Fast git hooks manager)"
  ["lf"]="📁 lf (Terminal file manager)"
  ["llm"]="🧠 LLM (Access Large Language Models)"
  ["lmstudio"]="🤖 LM Studio (Rode LLMs locais com interface gráfica)"
  ["lnav"]="📋 lnav (Log file navigator)"
  ["lsd"]="🌟 lsd (Modern ls replacement)"
  ["lychee"]="🔗 lychee (Fast link checker)"
  ["macchina"]="💻 macchina (System information fetcher)"
  ["mani"]="📂 mani (CLI tool to manage multiple repositories)"
  ["mcfly"]="🧠 mcfly (Fly through your shell history)"
  ["mdcat"]="🐈 mdcat (cat for Markdown)"
  ["melt"]="🔑 melt (Backup and restore Ed25519 SSH keys with seed words)"
  ["miller"]="📊 miller (jq for CSV TSV JSON JSONLines)"
  ["miniserve"]="🗄️ miniserve (Fast local file server)"
  ["mise"]="🛠️ Mise (Polyglot Tool Version Manager)"
  ["mkcert"]="🔐 mkcert (Simple zero-config tool to make locally trusted development certificates)"
  ["mlr"]="📊 mlr (jq for CSV TSV JSON)"
  ["moar"]="📄 moar (Better Pager)"
  ["mods"]="🤖 Mods (AI on the command line)"
  ["monolith"]="📦 monolith (Save HTML pages with all assets)"
  ["moon"]="🌙 Moon (Build system for JS TS)"
  ["mprocs"]="🔄 mprocs (Run multiple commands in parallel)"
  ["mysql"]="🐬 MySQL Server & Client (Bancos de Dados)"
  ["nap"]="😴 nap (Snippets Manager)"
  ["navi"]="🧭 navi (An interactive cheatsheet tool for the command-line)"
  ["ncspot"]="🎵 ncspot (Spotify client)"
  ["neovim"]="📝 Neovim (Editor de texto avançado)"
  ["netlify"]="▲ Netlify CLI (Deploy and manage sites)"
  ["newsboat"]="📰 newsboat (RSS Atom feed reader)"
  ["ngrok"]="🚇 ngrok (Secure introspectable tunnels to localhost)"
  ["nix"]="❄️ Nix (Modern package manager)"
  ["nomad"]="🚀 Nomad (Workload Orchestrator)"
  ["nuclei"]="⚡ nuclei (Targeted vulnerability scanner)"
  ["numbat"]="🧮 numbat (High precision scientific calculator)"
  ["nushell"]="🐚 Nushell (A new type of shell)"
  ["obsidian"]="📓 Obsidian (Second Brain & Notas)"
  ["oha"]="📈 Oha (HTTP Benchmarking)"
  ["ollama"]="🦙 Ollama (Rode LLMs localmente)"
  ["onefetch"]="📊 onefetch (Git Summary)"
  ["open-interpreter"]="🤖 Open-Interpreter (LLMs executando código)"
  ["opentofu"]="🏗️ OpenTofu (Infrastructure as Code)"
  ["ouch"]="🗜️ ouch (Painless compression and decompression)"
  ["oxker"]="🐳 oxker (Simple TUI to view & control docker containers)"
  ["oxlint"]="🐂 oxlint (Fast JS TS linter)"
  ["packer"]="📦 Packer (Build Automated Machine Images)"
  ["pastel"]="🎨 pastel (Command-line Color Tool)"
  ["peco"]="🔍 peco (Simplistic interactive filtering tool)"
  ["pipes-rs"]="🚰 pipes-rs (Animated pipes terminal screensaver)"
  ["pipes-sh"]="🚰 pipes-sh (Animated pipes screensaver)"
  ["pkgx"]="📦 pkgx (Blazing fast package manager)"
  ["plandex"]="🤖 Plandex (AI coding engine)"
  ["pls"]="🤖 pls (AI-powered CLI assistant)"
  ["pnpm"]="📦 pnpm (Fast package manager)"
  ["poetry"]="📦 poetry (Python packaging and dependency management made easy)"
  ["podman"]="🦭 Podman (Daemonless container engine)"
  ["pokeget"]="👾 pokeget (Show pokemon sprites in terminal)"
  ["pomsky"]="🐾 pomsky (Regex alternative)"
  ["popeye"]="👀 popeye (A Kubernetes cluster resource sanitizer)"
  ["porsmo"]="🍅 porsmo (Pomodoro CLI)"
  ["posting"]="📮 Posting (HTTP Client TUI)"
  ["presenterm"]="📽️ presenterm (Markdown presentations in terminal)"
  ["procs"]="🔍 Procs (A modern replacement for ps)"
  ["pueue"]="🗃️ Pueue (Command-line task management tool)"
  ["pulumi"]="🏗️ Pulumi (Infrastructure as Code)"
  ["px"]="📊 px (ps and top for Human Beings)"
  ["qsv"]="📊 qsv (CSV data-wrangling toolkit)"
  ["repomix"]="📦 Repomix (Pack repo for AI)"
  ["rip"]="🗑️ rip (A safe and ergonomic alternative to rm)"
  ["ripgrep"]="⚡ Ripgrep (Line-oriented search tool)"
  ["ripgrep_all"]="📦 ripgrep_all (rga - search PDFs E-Books Office docs)"
  ["rnr"]="🔄 rnr (A command-line tool to rename files and directories safely)"
  ["rs-cmatrix"]="💻 rs-cmatrix (Matrix rain in Rust)"
  ["ruff"]="⚡ Ruff (Extremely fast Python linter)"
  ["ruplacer"]="🔄 ruplacer (Find and replace text in source files)"
  ["rustscan"]="🔍 rustscan (The Modern Port Scanner)"
  ["rye"]="🌾 Rye (Hassle-free Python experience)"
  ["sad"]="😢 sad (CLI search and replace)"
  ["scc"]="📊 scc (Sloc Cloc and Code)"
  ["sd"]="🔍 sd (Search & Displace)"
  ["serie"]="📈 serie (Git commit graph CLI)"
  ["serpl"]="🔍 serpl (Search and replace TUI)"
  ["sesh"]="🖥️ sesh (Smart Session Manager)"
  ["shell-gpt"]="💬 Shell-GPT (ChatGPT from terminal)"
  ["shellcheck"]="🐚 shellcheck (A static analysis tool for shell scripts)"
  ["shfmt"]="✨ shfmt (A shell parser formatter and interpreter)"
  ["silicon"]="📸 silicon (Create beautiful image of your source code)"
  ["skate"]="🔑 skate (A personal key-value store)"
  ["skim"]="🔍 skim (Fuzzy Finder in Rust)"
  ["slack"]="💬 Slack Desktop (Comunicação)"
  ["slides"]="📊 slides (Terminal based presentation tool)"
  ["slumber"]="😴 Slumber (Terminal HTTP Client)"
  ["sniffnet"]="🕸️ sniffnet (Network traffic monitor)"
  ["so"]="🔍 so (StackOverflow in terminal)"
  ["sops"]="🔐 sops (Simple and flexible tool for managing secrets)"
  ["spacer"]="📏 spacer (CLI tool to insert spacers when command output stops)"
  ["spt"]="🎵 spt (Spotify TUI)"
  ["sqlc"]="🗄️ sqlc (Generate type-safe code from SQL)"
  ["starship"]="🚀 Starship Prompt (Synthwave '84 ativado)"
  ["steampipe"]="☁️ steampipe (Query cloud resources with SQL)"
  ["stern"]="📋 stern (Multi pod and container log tailing for Kubernetes)"
  ["stripe"]="💳 Stripe CLI (Interact with Stripe API)"
  ["supabase"]="⚡ supabase (Supabase CLI)"
  ["superfile"]="📁 Superfile (Terminal File Manager)"
  ["syft"]="📦 syft (CLI tool and library for generating a SBOM)"
  ["systemctl-tui"]="⚙️ systemctl-tui (A fast simple TUI for interacting with systemd services and their logs)"
  ["systeroid"]="🧠 systeroid (A more powerful alternative to sysctl(8) with a terminal user interface)"
  ["sysz"]="⚙️ sysz (A fzf terminal UI for systemctl)"
  ["t-rec"]="📼 t-rec (Blazing fast terminal recorder)"
  ["tailspin"]="🪵 tailspin (Log Highlighter)"
  ["taplo"]="⚙️ taplo (TOML toolkit)"
  ["task"]="✅ task (Modern Make alternative)"
  ["taskwarrior-tui"]="✅ taskwarrior-tui (A TUI for Taskwarrior)"
  ["tealdeer"]="🦌 Tealdeer (A very fast implementation of tldr in Rust)"
  ["television"]="📺 television (Blazing fast fuzzy finder)"
  ["tenki"]="⛅ tenki (Weather in terminal)"
  ["tenv"]="🌍 tenv (OpenTofu Terraform Terragrunt and Atmos version manager)"
  ["termdbms"]="🗄️ termdbms (A TUI for viewing and (eventually) editing database files)"
  ["termscp"]="📁 termscp (Terminal file transfer)"
  ["termshark"]="🦈 termshark (A terminal UI for tshark inspired by Wireshark)"
  ["termtyper"]="⌨️ termtyper (A typing test in your terminal)"
  ["terragrunt"]="🏗️ Terragrunt (Thin wrapper for Terraform)"
  ["tflint"]="🔍 TFLint (Terraform linter)"
  ["tfsec"]="🛡️ tfsec (Security scanner for your Terraform code)"
  ["tgpt"]="🤖 tgpt (Terminal ChatGPT)"
  ["thefuck"]="🤬 thefuck (Magnificent app which corrects your previous console command)"
  ["tickrs"]="📈 tickrs (Real-time ticker data in terminal)"
  ["tilt"]="🛠️ tilt (A multi-service dev environment for teams on Kubernetes)"
  ["tin-summer"]="☀️ tin-summer (Find build artifacts that take up disk space)"
  ["tldr"]="📚 tldr (Collaborative cheatsheets for console commands)"
  ["tlrc"]="📚 tlrc (Official tldr client)"
  ["tmate"]="🤝 tmate (Instant terminal sharing)"
  ["tmux"]="🪟 tmux (Terminal multiplexer)"
  ["tokei"]="⏰ Tokei (Code Statistics)"
  ["topgrade"]="🚀 topgrade (Upgrade Everything)"
  ["trash-cli"]="🗑️ trash-cli (Safer rm)"
  ["tre"]="🌲 tre (Tree command improved)"
  ["trippy"]="🗺️ trippy (Network Diagnostic)"
  ["trivy"]="🛡️ trivy (Vulnerability Scanner)"
  ["trufflehog"]="🐷 trufflehog (Find and verify secrets)"
  ["trzsz"]="📤 trzsz (A simple file transfer tools similar to lrzsz (rz sz) and compatible with tmux)"
  ["tt"]="⌨️ tt (A terminal based typing test)"
  ["ttyd"]="🌐 ttyd (Share your terminal over the web)"
  ["ttyper"]="⌨️ ttyper (Terminal-based typing test)"
  ["turso"]="🗄️ turso (Turso CLI)"
  ["typos"]="📝 typos (Source code spell checker)"
  ["typos-cli"]="📝 typos-cli (Source code spell checker)"
  ["typst"]="📝 typst (Markup-based typesetting system)"
  ["ugit"]="⏪ ugit (Undo git commands)"
  ["ugrep"]="🔍 ugrep (Ultra fast grep with interactive query UI)"
  ["usql"]="🗄️ usql (Universal command-line interface for SQL databases)"
  ["uv"]="🐍 uv (Gerenciador Python ultrarrápido em Rust)"
  ["vault"]="🔐 Vault (Manage Secrets and Protect Sensitive Data)"
  ["vcluster"]="⎈ vcluster (Virtual Kubernetes Clusters)"
  ["vegeta"]="🔫 vegeta (HTTP load testing tool and library)"
  ["vercel"]="▲ Vercel CLI (Deploy serverless applications)"
  ["vhs"]="📼 vhs (Terminal GIF Recorder)"
  ["viddy"]="⌚ viddy (Modern watch command)"
  ["visidata"]="📊 visidata (A terminal spreadsheet multitool for discovering and arranging data)"
  ["viu"]="🖼️ viu (Simple terminal image viewer)"
  ["vivid"]="🌈 vivid (Generator for LS_COLORS)"
  ["vscode"]="💻 Visual Studio Code (Setup Moderno)"
  ["walk"]="🚶 walk (Terminal file manager)"
  ["warp"]="⚡ Warp Terminal (AI & GPU Acelerado)"
  ["watchexec"]="👀 watchexec (Executes commands in response to file modifications)"
  ["waypoint"]="🎯 waypoint (Modern application deployment)"
  ["websocat"]="🌐 websocat (Command-line client for WebSockets)"
  ["wezterm"]="💻 WezTerm (Emulador de terminal acelerado por GPU)"
  ["wiki-tui"]="📖 wiki-tui (Wikipedia TUI)"
  ["windsurf"]="🏄 Windsurf (AI IDE da Codeium)"
  ["wtf"]="🖥️ wtf (Personal information dashboard)"
  ["wtfutil"]="🖥️ wtfutil (Personal information dashboard)"
  ["wthrr"]="🌦️ wthrr (Weather crab)"
  ["wthrr-the-weathercrab"]="🌦️ wthrr-the-weathercrab (Weather crab)"
  ["wuzz"]="🌐 wuzz (Interactive cli tool for HTTP inspection)"
  ["xc"]="📝 xc (Markdown task runner)"
  ["xcp"]="🚀 xcp (Extended cp)"
  ["xh"]="🌐 xh (Friendly and fast tool for sending HTTP requests)"
  ["xplr"]="📁 xplr (TUI file explorer)"
  ["xsv"]="📊 xsv (High performance CSV toolkit)"
  ["yamlfmt"]="✨ yamlfmt (An extensible command line tool or library to format yaml files)"
  ["yazi"]="🦆 Yazi File Manager (Arquivos na velocidade da luz)"
  ["yq"]="🔍 yq (Command-line YAML processor)"
  ["yt-dlp"]="🎥 yt-dlp (Video downloader)"
  ["zed"]="💻 Zed Editor (Escrito em Rust)"
  ["zellij"]="🪟 Zellij Terminal Multiplexer (Workspace Moderno)"
  ["zen-browser"]="🌐 Zen Browser (Navegador ultrarrápido focado em privacidade)"
  ["zenith"]="📈 zenith (System Monitor with Charts)"
  ["zig"]="⚡ Zig (Modern programming language)"
  ["zizmor"]="🛡️ zizmor (Static analysis tool for GitHub Actions)"
  ["zoxide"]="🚀 Zoxide (A smarter cd command)"
  ["zrok"]="🔗 zrok (Open source ngrok alternative)"
  ["zsh"]="🐚 Zsh shell e plugins (Hiper-produtividade)"
  ["gptme"]="🤖 gptme (CLI AI agent)"
  ["micro"]="🚀 micro (Modern and intuitive terminal-based text editor)"
  ["nnn"]="🚀 nnn (Free fast feature-packed file manager)"
  ["tig"]="🚀 tig (Text-mode interface for Git)"
  ["ncdu"]="🚀 ncdu (NCurses Disk Usage)"
  ["kakoune"]="🚀 kakoune (Better Vim)"
  ["kubent"]="☸️ kubent (Kubernetes deprecated API checker)"
  ["lazyvim"]="💤 lazyvim (Neovim starter)"
  ["litecli"]="🗃️ litecli (SQLite CLI with auto-completion and syntax highlighting)"
  ["mycli"]="🐬 mycli (MySQL CLI with auto-completion and syntax highlighting)"
  ["oh-my-posh"]="🎨 oh-my-posh (Prompt theme engine)"
  ["pgcli"]="🐘 pgcli (Postgres CLI with auto-completion and syntax highlighting)"
  ["tere"]="🚀 tere (Faster cd tree alternative)"
  ["ffuf"]="🔍 ffuf (Fast web fuzzer written in Go)"
  ["tmate"]="🤝 tmate (Instant terminal sharing)"
  ["kaskade"]="🌊 kaskade (Kafka TUI)"
)

# Get all available modules
ALL_MODULES=()
for dir in "$ROOT_DIR"/programas/*/; do
  mod=$(basename "$dir")
  # Exclude 'common' or other non-installable modules if necessary
  if [[ "$mod" != "common" && -f "$dir/setup.sh" ]]; then
    ALL_MODULES+=("$mod")
  fi
done

# Sort ALL_MODULES alphabetically to improve the interface
mapfile -t ALL_MODULES < <(IFS=$'
'; sort <<<"${ALL_MODULES[*]}")


if command -v "$GUM" &> /dev/null; then
  echo ""
  "$GUM" style \
    --foreground "#fede5d" --bold \
    --border double --border-foreground "#ff7edb" \
    --padding "1 4" --margin "1 0" --align center --width 100 \
    "Selecione os módulos que deseja instalar:" \
    "$($GUM style --foreground "#6272a4" "[Espaço] marcar / [Enter] confirmar / [/] buscar")"
  echo ""

  # Prepare choices with descriptions
  CHOICES=()
  for mod in "${ALL_MODULES[@]}"; do
    desc="${MOD_DESC[$mod]:-🚀 $mod}"
    CHOICES+=("$mod - $desc")
  done

  # Prepare comma-separated default modules string with descriptions
  DEFAULTS_DESC=()
  for mod in "${DEFAULT_MODULES[@]}"; do
    desc="${MOD_DESC[$mod]:-🚀 $mod}"
    DEFAULTS_DESC+=("$mod - $desc")
  done
  DEFAULTS=$(IFS=,; echo "${DEFAULTS_DESC[*]}")

  # Interactive selection
  # Note: Use `gum choose` because it supports `--selected` natively (unlike `gum filter`),
  # allowing us to pre-select modules based on the chosen profile.
  # We increased the height and added a search hint (use '/' to search in modern gum).
  SELECTED_TEXT=$("$GUM" choose --no-limit --cursor="⚡ " \
    --height=35 \
    --selected="${DEFAULTS}" \
    --selected.background="#bd93f9" \
    --selected.foreground="#282a36" \
    --selected.bold \
    --cursor.foreground="#ff7edb" \
    --item.foreground="#f8f8f2" \
    --header="🚀 $($GUM style --foreground "#ff7edb" --bold "CATÁLOGO DE MÓDULOS 2026") (pressione '/' para buscar):" \
    --header.foreground="#fede5d" \
    --header.bold \
    "${CHOICES[@]}")

  # Extract module directories from the selected text
  MODULES=()
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      mod="${line%% *}"
      MODULES+=("$mod")
    fi
  done <<< "$SELECTED_TEXT"

  echo ""
  "$GUM" style --foreground "#72f1b8" --bold "📦 Módulos que serão instalados:"
  MOD_LIST=""
  for mod in "${MODULES[@]}"; do
    if [ -n "$mod" ]; then
      desc="${MOD_DESC[$mod]:-🚀 $mod}"
      MOD_LIST+="  $($GUM style --foreground "#ff7edb" "•") $($GUM style --foreground "#fede5d" "$mod") $($GUM style --foreground "#6272a4" "($desc)")"$'\n'
    fi
  done
  # Remove trailing newline for cleaner tailing
  MOD_LIST="${MOD_LIST%$'\n'}"

  # Dynamically calculate columns based on module count
  num_mods=${#MODULES[@]}
  if [ $num_mods -gt 120 ]; then cols=6;
  elif [ $num_mods -gt 80 ]; then cols=5;
  elif [ $num_mods -gt 60 ]; then cols=4;
  elif [ $num_mods -gt 30 ]; then cols=3;
  elif [ $num_mods -gt 15 ]; then cols=2;
  else cols=1; fi

  if [ $cols -gt 1 ]; then
    rows=$(( (num_mods + cols - 1) / cols ))
    join_args=()
    for ((i=0; i<cols; i++)); do
      join_args+=("$(echo -e "$MOD_LIST" | tail -n +$((i * rows + 1)) | head -n $rows)")
      if [ $i -lt $((cols - 1)) ]; then
        join_args+=("  ")
      fi
    done
    echo "$("$GUM" join --horizontal "${join_args[@]}")" | "$GUM" style --border double --margin "1 2" --padding "2 4" --border-foreground "#36f9f6"
  else
    echo -e "$MOD_LIST" | "$GUM" style --border double --margin "1 2" --padding "2 4" --border-foreground "#36f9f6"
  fi
  echo ""
else
  MODULES=("${DEFAULT_MODULES[@]}")
  log "Módulos padrão: ${MODULES[*]}"
fi

# Ensure MODULES is not empty
if [ ${#MODULES[@]} -eq 0 ] || [ -z "${MODULES[0]}" ]; then
  log "Nenhum módulo selecionado. Saindo..."
  exit 0
fi

if command -v "$GUM" &> /dev/null; then
  DRY_BADGE=""
  if [[ "$DRY_RUN" == true ]]; then
    DRY_BADGE=$("$GUM" style --foreground "#282a36" --background "#fede5d" --bold --padding "0 1" " DRY RUN ")
  fi
  SUMMARY_BOX=$("$GUM" style \
    --foreground "#f8f8f2" --border-foreground "#ff7edb" --border double \
    --align center --width 65 --margin "2 2" --padding "3 5" \
    "🚀 $($GUM style --foreground "#fede5d" --bold "RESUMO DA INSTALAÇÃO") 🚀" \
    "$DRY_BADGE" \
    "" \
    "Perfil: $($GUM style --foreground "#36f9f6" --bold "$PROFILE")" \
    "Total de Módulos: $($GUM style --foreground "#72f1b8" --bold "${#MODULES[@]}")")
  echo "$SUMMARY_BOX"
  echo ""
  if [[ "$DRY_RUN" == false ]]; then
    if ! "$GUM" confirm \
      --prompt.foreground "#ff7edb" \
      --unselected.background "" \
      --unselected.foreground "#f8f8f2" \
      --selected.background "#72f1b8" \
      --selected.foreground "#282a36" \
      --affirmative "🚀 Vamos lá!" \
      --negative "🛑 Cancelar" \
      "⚠️ Atenção: Pronto para dar o salto hiperespacial e reescrever sua realidade?"; then
      log "Instalação cancelada pelo usuário."
      exit 0
    fi
    echo ""
  fi
else
  echo "Resumo da Instalação:"
  if [[ "$DRY_RUN" == true ]]; then
    echo "[ DRY RUN MODO ATIVADO - NADA SERÁ INSTALADO ]"
  fi
  echo "Perfil: $PROFILE"
  echo "Total de Módulos: ${#MODULES[@]}"
  if [[ "$DRY_RUN" == false ]]; then
    read -rp "Deseja prosseguir com a instalação destes módulos? (S/n): " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
      log "Instalação cancelada pelo usuário."
      exit 0
    fi
  fi
fi

if [[ "$DRY_RUN" == false ]] && command -v sudo &> /dev/null; then
  sudo -v
  # Keep-alive: update existing sudo time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

TOTAL_MODULES=${#MODULES[@]}
CURRENT_MODULE=1

for module in "${MODULES[@]}"; do
  if [[ ! -f "$ROOT_DIR/programas/$module/setup.sh" ]]; then
    log "Módulo ignorado (setup inexistente): $module"
    continue
  fi

  run_module "$module" "$CURRENT_MODULE" "$TOTAL_MODULES"
  CURRENT_MODULE=$((CURRENT_MODULE + 1))
done

END_TIME=$(date +%s)
ELAPSED_TIME=$(($END_TIME - $START_TIME))
ELAPSED_MINUTES=$(($ELAPSED_TIME / 60))
ELAPSED_SECONDS=$(($ELAPSED_TIME % 60))

if command -v "$GUM" &> /dev/null; then
  ART_BOX=$("$GUM" style \
    --foreground "#36f9f6" --border double --border-foreground "#ff7edb" \
    --padding "2 4" --margin "1 2" --align center \
    '   _____ __  __   __   ' \
    '  / ___// / / /  / /   ' \
    '  \__ \/ /_/ /  / /    ' \
    ' ___/ / __  /  / /___  ' \
    '/____/_/ /_/  /_____/  ' \
    '                       ' \
    '    ⚡ 2026 ⚡     ')
  TEXT_BOX=$("$GUM" style \
      --foreground "#f8f8f2" --background "#282a36" --border-foreground "#bd93f9" \
    --border double --align center --width 75 --margin "1 2" --padding "2 3" \
      "🚀 $($GUM style --foreground "#36f9f6" "TRANSMISSÃO CONCLUÍDA!") 🛸" \
      "Perfil $($GUM style --foreground "#282a36" --background "#72f1b8" " $PROFILE ") ativado com sucesso!" \
      "Tempo total de salto: $($GUM style --foreground "#fede5d" "${ELAPSED_MINUTES}m ${ELAPSED_SECONDS}s")" \
      "" \
      "Módulos com sucesso: $($GUM style --foreground "#72f1b8" "$SUCCESS_COUNT")" \
      "Módulos com falha: $($GUM style --foreground "#ff7edb" "$FAIL_COUNT")" \
      "" \
      "🔮 $($GUM style --foreground "#fede5d" "A matrix foi atualizada e está pronta para uso.") 🔮" \
      "Feche este terminal e abra um novo para carregar sua nova realidade." \
      "" \
      "📂 $($GUM style --foreground "#bd93f9" "Logs salvos em: /tmp/setup-2026-*.log")")
  echo "$("$GUM" join --align center "$ART_BOX" "$TEXT_BOX")"
else
  log "Finalizado com sucesso em ${ELAPSED_MINUTES}m ${ELAPSED_SECONDS}s. Reinicie seu terminal."
  log "Sucesso: $SUCCESS_COUNT | Falha: $FAIL_COUNT"
  log "Logs de instalação disponíveis em: /tmp/setup-2026-*.log"
fi

# Cleanup
if [ -n "$TMP_GUM_DIR" ] && [ -d "$TMP_GUM_DIR" ]; then
    rm -rf "$TMP_GUM_DIR"
fi
