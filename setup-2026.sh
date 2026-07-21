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
    wget -qO "$TMP_GUM_DIR/gum.tar.gz" https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_linux_x86_64.tar.gz
    # The tarball directly contains the 'gum' binary
    tar -xzf "$TMP_GUM_DIR/gum.tar.gz" -C "$TMP_GUM_DIR" gum
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
    run_step "$progress_prefix Executando módulo: $module" "$script"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    if command -v "$GUM" &> /dev/null; then
      if "$GUM" spin --spinner globe --spinner.foreground "#36f9f6" --title "$($GUM style --foreground "#fede5d" "$progress_prefix Iniciando salto quântico:") $($GUM style --foreground "#ff7edb" "$module...")" -- bash -c '"$1" > "/tmp/setup-2026-$2.log" 2>&1' -- "$script" "$module"; then
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
      --align center --width 80 --margin "1 2" --padding "2 4" \
      ' ▂▃▄▅▆▇█▓▒░ NEXUS DOTFILES 2026 ░▒▓█▇▆▅▄▃▂ ' \
      '' \
      '██████╗  ██████╗ ██████╗  ██████╗ ' \
      '╚════██╗██╔═████╗╚════██╗██╔════╝ ' \
      ' █████╔╝██║██╔██║ █████╔╝███████╗ ' \
      '██╔═══╝ ████╔╝██║██╔═══╝ ██╔═══██╗' \
      '███████╗╚██████╔╝███████╗╚██████╔╝' \
      '╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ' \
      '' \
      "$($GUM style --foreground "#36f9f6" --bold '⚡ THE ULTIMATE CYBERPUNK EXPERIENCE ⚡')" \
      "$($GUM style --foreground "#72f1b8" 'A Matrix Foi Atualizada. O Futuro é Agora.')")

    INFO=$("$GUM" style \
      --foreground "#36f9f6" --border-foreground "#ff7edb" --border rounded \
      --align left --width 40 --margin "1 2" --padding "2 4" \
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
      "⏱️ Uptime: $($GUM style --foreground "#ff7edb" "$UPTIME_INFO")")

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
      --cursor="✨ " \
      --header="Escolha o seu nível de poder no Nexus:" \
      --header.foreground="#ff7edb" \
      --cursor.foreground="#72f1b8" \
      --item.foreground="#f8f8f2" \
      --selected.foreground="#36f9f6" \
      "minimal   - 🪶 Shell moderna, prompt limpo, e editor ultrarrápido. (Essencial)." \
      "dev       - 🚀 minimal + Runtimes JS/Python, Docker e BD. (Recomendado para Ninjas)." \
      "full      - 🌌 dev + Apps extras de produtividade (Navegador, Slack, Android)." \
      "ai-dev    - 🤖 minimal + Cursor, Zed, Warp e Apps de AI. (O Futuro Agora).")
    PROFILE=$(echo "$PROFILE_CHOICE" | awk '{print $1}')
  else
    read -rp "Escolha o perfil (minimal, dev, full, ai-dev) [full]: " PROFILE
    PROFILE=${PROFILE:-full}
  fi
fi

case "$PROFILE" in
  minimal)
    DEFAULT_MODULES=(eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship vscode sd choose gobang bottom macchina xplr circumflex lsd)
    ;;
  dev)
    DEFAULT_MODULES=(eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd)
    ;;
  full)
    DEFAULT_MODULES=(eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric fastfetch fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum harlequin hck helix helm hexyl howdoi htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugrep usql uv vcluster vegeta vhs viddy visidata viu vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok)
    ;;
  ai-dev)
    DEFAULT_MODULES=(eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp lazygit lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s posting superfile aider plandex open-interpreter duckdb harlequin fastfetch lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd)
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
  ["actionlint"]="📦 actionlint (Modern CLI tool)"
  ["age"]="📦 age (Modern CLI tool)"
  ["aichat"]="💬 aichat (AI Chat)"
  ["aider"]="🤖 Aider-chat (AI pair programming)"
  ["amber"]="🔍 amber (Search & Replace)"
  ["android"]="📱 Android Studio & SDK (Plataforma Mobile)"
  ["ast-grep"]="🌳 ast-grep (AST based search/replace)"
  ["atac"]="🚀 Atac (Modern API Client TUI)"
  ["atlas"]="📦 atlas (Modern CLI tool)"
  ["atuin"]="🐢 Atuin (Magical Shell History)"
  ["bacon"]="🥓 bacon (Background Rust code checker)"
  ["bandwhich"]="📈 bandwhich (Bandwidth Monitor)"
  ["bat"]="🦇 Bat (A cat clone with wings)"
  ["bat-extras"]="📦 bat-extras (Modern CLI tool)"
  ["binsider"]="📦 binsider (Modern CLI tool)"
  ["biome"]="🚀 Biome (Fast JS/TS toolchain)"
  ["bluetuith"]="📦 bluetuith (Modern CLI tool)"
  ["bore-cli"]="📦 bore-cli (Modern CLI tool)"
  ["bottom"]="📈 bottom (System Monitor)"
  ["brave"]="🦁 Brave (Navegador focado em privacidade)"
  ["broot"]="🌲 Broot (A new way to see and navigate directory trees)"
  ["bruno"]="🐶 Bruno (API Client open-source e leve)"
  ["btop"]="📊 Btop (A monitor of resources)"
  ["bun"]="🥟 Bun JavaScript runtime (Ultrarrápido)"
  ["carapace"]="🐚 carapace (Multi-shell Completer)"
  ["cbonsai"]="🌲 cbonsai (Terminal bonsai tree)"
  ["chafa"]="📦 chafa (Modern CLI tool)"
  ["charm"]="📦 charm (Modern CLI tool)"
  ["chatbox"]="💬 Chatbox (Copilot for your desktop)"
  ["chatgpt-cli"]="📦 chatgpt-cli (Modern CLI tool)"
  ["cheat"]="📦 cheat (Modern CLI tool)"
  ["checkov"]="📦 checkov (Modern CLI tool)"
  ["choose"]="✂️ choose (Human-friendly cut)"
  ["circumflex"]="📰 circumflex (Hacker News in terminal)"
  ["claude-code"]="🤖 Claude Code (AI Assistant CLI da Anthropic)"
  ["cli-tools"]="🧰 O Arsenal Definitivo 2026 (Ferramentas CLI)"
  ["cline"]="🤖 Cline (Autonomous coding agent CLI)"
  ["cloudflared"]="📦 cloudflared (Modern CLI tool)"
  ["cocogitto"]="📦 cocogitto (Modern CLI tool)"
  ["code2prompt"]="📝 code2prompt (Convert codebase to LLM prompt)"
  ["cointop"]="🪙 cointop (Crypto tracker)"
  ["common"]="⚙️ Scripts compartilhados e helpers"
  ["cpufetch"]="📦 cpufetch (Modern CLI tool)"
  ["crane"]="📦 crane (Modern CLI tool)"
  ["croc"]="🐊 croc (Securely send things between computers)"
  ["csvlens"]="📊 csvlens (CSV viewer)"
  ["ctop"]="📦 ctop (Modern CLI tool)"
  ["curlie"]="🦱 Curlie (curl + httpie)"
  ["cursor"]="🤖 Cursor AI Code Editor (Futuro do código)"
  ["czg"]="📦 czg (Modern CLI tool)"
  ["d2"]="📊 d2 (Declarative Diagramming)"
  ["dagger"]="🗡️ Dagger (Programmable CI/CD engine)"
  ["dasel"]="🔍 dasel (Query/update data formats)"
  ["daytona"]="🌅 Daytona (Self-hosted development environment manager)"
  ["dbeaver"]="🐘 DBeaver (Cliente universal para bancos de dados)"
  ["dbmate"]="🗃️ dbmate (Database migration tool)"
  ["delta"]="🔀 delta (A syntax-highlighting pager for git, diff, and grep output)"
  ["deno"]="🦕 Deno (Modern JS/TS runtime)"
  ["devbox"]="📦 Devbox (Portable Developer Environments)"
  ["devenv"]="⚙️ Devenv (Declarative Developer Environments)"
  ["devpod"]="🚀 DevPod (Codespaces but open-source)"
  ["difftastic"]="🧬 difftastic (Structural diff)"
  ["direnv"]="📦 direnv (Modern CLI tool)"
  ["discord"]="🎮 Discord (Comunicação de voz e texto)"
  ["diskonaut"]="📦 diskonaut (Modern CLI tool)"
  ["distrobox"]="📦 Distrobox (Run any linux distro in terminal)"
  ["dive"]="🐳 dive (Docker image explorer)"
  ["docker"]="🐳 Docker Engine (Contêineres)"
  ["doggo"]="🐶 Doggo (Modern DNS Client)"
  ["dolt"]="📦 dolt (Modern CLI tool)"
  ["dotenv-linter"]="📦 dotenv-linter (Modern CLI tool)"
  ["dotenvx"]="📦 dotenvx (Modern CLI tool)"
  ["dprint"]="📦 dprint (Modern CLI tool)"
  ["dsq"]="🗃️ dsq (SQL for JSON, CSV, etc.)"
  ["dua"]="💽 dua (Disk Usage Analyzer)"
  ["dua-cli"]="📦 dua-cli (Modern CLI tool)"
  ["duckdb"]="🦆 DuckDB (In-process SQL OLAP DBMS)"
  ["duf"]="📦 duf (Modern CLI tool)"
  ["dufs"]="📁 dufs (Utility file server)"
  ["dura"]="📦 dura (Modern CLI tool)"
  ["dust"]="🌪️ dust (A more intuitive version of du in rust)"
  ["dysk"]="📦 dysk (Modern CLI tool)"
  ["earthly"]="📦 earthly (Modern CLI tool)"
  ["eget"]="📦 eget (Modern CLI tool)"
  ["erdtree"]="🌳 erdtree (File-tree Visualizer)"
  ["evans"]="📦 evans (Modern CLI tool)"
  ["eza"]="🌟 Eza (A modern, maintained replacement for ls)"
  ["fabric"]="🤖 fabric (AI CLI framework)"
  ["fastfetch"]="⚡ Fastfetch (Modern System Info)"
  ["fd-find"]="📂 fd (A simple, fast and user-friendly alternative to find)"
  ["fend"]="🧮 fend (Arbitrary-precision unit-aware calculator)"
  ["firefox"]="🦊 Navegador Firefox (Otimizado)"
  ["flox"]="❄️ Flox (Developer environments for everyone)"
  ["flyctl"]="📦 flyctl (Modern CLI tool)"
  ["fnm"]="🐢 fnm (Fast Node Manager)"
  ["fq"]="📦 fq (Modern CLI tool)"
  ["freeze"]="📦 freeze (Modern CLI tool)"
  ["fx"]="📦 fx (Modern CLI tool)"
  ["fzf"]="🔍 Fzf (A command-line fuzzy finder)"
  ["gcloud"]="📦 gcloud (Modern CLI tool)"
  ["gdu"]="📊 gdu (Disk usage analyzer)"
  ["genact"]="📦 genact (Modern CLI tool)"
  ["gh"]="🐙 gh (GitHub CLI)"
  ["gh-dash"]="📦 gh-dash (Modern CLI tool)"
  ["ghostty"]="👻 Ghostty (Emulador de Terminal Ultrarrápido)"
  ["ghq"]="📦 ghq (Modern CLI tool)"
  ["git-absorb"]="📦 git-absorb (Modern CLI tool)"
  ["git-cliff"]="⛰️ git-cliff (Changelog Generator)"
  ["git-filter-repo"]="📦 git-filter-repo (Modern CLI tool)"
  ["git-sim"]="📦 git-sim (Modern CLI tool)"
  ["git-town"]="📦 git-town (Modern CLI tool)"
  ["gitingest"]="🧠 Gitingest (Git to AI prompt)"
  ["gitleaks"]="🔐 gitleaks (Secret scanner for git)"
  ["gitui"]="🐙 GitUI (Blazing Fast Git TUI)"
  ["glab"]="📦 glab (Modern CLI tool)"
  ["glances"]="👀 glances (System monitor)"
  ["glow"]="🌟 Glow (Markdown Renderer)"
  ["gobang"]="🗃️ gobang (Cross-platform Database Client TUI)"
  ["gojq"]="📦 gojq (Modern CLI tool)"
  ["gping"]="🏓 gping (Ping, but with a graph)"
  ["grex"]="🧠 grex (Regex Generator)"
  ["gron"]="🔧 gron (Make JSON greppable)"
  ["grpcurl"]="📦 grpcurl (Modern CLI tool)"
  ["grype"]="📦 grype (Modern CLI tool)"
  ["gtt"]="📦 gtt (Modern CLI tool)"
  ["gum"]="📦 gum (Modern CLI tool)"
  ["harlequin"]="🎩 Harlequin (SQL IDE for terminal)"
  ["hck"]="📦 hck (Modern CLI tool)"
  ["helix"]="🧬 Helix (Post-modern text editor)"
  ["helm"]="📦 helm (Modern CLI tool)"
  ["hexyl"]="🔢 hexyl (Hex viewer)"
  ["howdoi"]="📦 howdoi (Modern CLI tool)"
  ["htmlq"]="📦 htmlq (Modern CLI tool)"
  ["httpie"]="📦 httpie (Modern CLI tool)"
  ["httpstat"]="📦 httpstat (Modern CLI tool)"
  ["httpx"]="📦 httpx (Modern CLI tool)"
  ["hurl"]="📦 hurl (Modern CLI tool)"
  ["hwatch"]="📦 hwatch (Modern CLI tool)"
  ["hyperfine"]="⏱️ Hyperfine (A command-line benchmarking tool)"
  ["igrep"]="📦 igrep (Modern CLI tool)"
  ["infracost"]="📦 infracost (Modern CLI tool)"
  ["inlyne"]="🖥️ inlyne (GPU powered markdown viewer)"
  ["inshellisense"]="💡 Inshellisense (IDE style autocomplete for shells)"
  ["jan"]="🤖 Jan (Local AI alternative to ChatGPT)"
  ["jaq"]="📦 jaq (Modern CLI tool)"
  ["jc"]="📦 jc (Modern CLI tool)"
  ["jira-cli"]="📦 jira-cli (Modern CLI tool)"
  ["jj"]="🐙 jj (Git alternative)"
  ["jless"]="🔍 Jless (JSON Viewer)"
  ["jnv"]="📦 jnv (Modern CLI tool)"
  ["jo"]="🔧 jo (JSON output utility)"
  ["joshuto"]="📁 joshuto (Terminal file manager)"
  ["jq"]="📦 jq (Modern CLI tool)"
  ["jql"]="📦 jql (Modern CLI tool)"
  ["jqp"]="📦 jqp (Modern CLI tool)"
  ["jujutsu"]="📦 jujutsu (Modern CLI tool)"
  ["just"]="🤖 Just (Command Runner)"
  ["k3d"]="📦 k3d (Modern CLI tool)"
  ["k6"]="🚀 k6 (Modern load testing tool)"
  ["k8sgpt"]="☸️ k8sgpt (AI for Kubernetes)"
  ["k9s"]="🐶 k9s (Kubernetes CLI TUI)"
  ["kalker"]="📦 kalker (Modern CLI tool)"
  ["kdash"]="☸️ kdash (Kubernetes Dashboard)"
  ["kind"]="📦 kind (Modern CLI tool)"
  ["klog"]="📦 klog (Modern CLI tool)"
  ["kmon"]="📦 kmon (Modern CLI tool)"
  ["ko"]="📦 ko (Modern CLI tool)"
  ["kondo"]="🧹 kondo (Clean up software projects)"
  ["krew"]="📦 krew (Modern CLI tool)"
  ["kubecolor"]="📦 kubecolor (Modern CLI tool)"
  ["kubectl"]="📦 kubectl (Modern CLI tool)"
  ["kubectx"]="📦 kubectx (Modern CLI tool)"
  ["kustomize"]="📦 kustomize (Modern CLI tool)"
  ["lazydocker"]="🐳 LazyDocker TUI (Contêineres com Estilo)"
  ["lazygit"]="🐙 LazyGit TUI (Git feito certo)"
  ["lazynpm"]="📦 Lazynpm (NPM TUI)"
  ["lazysql"]="🦥 Lazysql (SQL Client TUI)"
  ["lefthook"]="📦 lefthook (Modern CLI tool)"
  ["lf"]="📦 lf (Modern CLI tool)"
  ["llm"]="🧠 LLM (Access Large Language Models)"
  ["lmstudio"]="🧠 LM Studio (Rode LLMs locais com interface gráfica)"
  ["lnav"]="📦 lnav (Modern CLI tool)"
  ["lsd"]="🌟 lsd (Modern ls replacement)"
  ["lychee"]="📦 lychee (Modern CLI tool)"
  ["macchina"]="💻 macchina (System information fetcher)"
  ["mani"]="📦 mani (Modern CLI tool)"
  ["mcfly"]="📦 mcfly (Modern CLI tool)"
  ["mdcat"]="📦 mdcat (Modern CLI tool)"
  ["melt"]="📦 melt (Modern CLI tool)"
  ["miller"]="📦 miller (Modern CLI tool)"
  ["miniserve"]="🗄️ miniserve (Fast local file server)"
  ["mise"]="🛠️ Mise (Polyglot Tool Version Manager)"
  ["mkcert"]="📦 mkcert (Modern CLI tool)"
  ["moar"]="📄 moar (Better Pager)"
  ["mods"]="🤖 Mods (AI on the command line)"
  ["monolith"]="📦 monolith (Modern CLI tool)"
  ["moon"]="🌙 Moon (Build system for JS/TS)"
  ["mprocs"]="🔄 mprocs (Run multiple commands in parallel)"
  ["mysql"]="🐬 MySQL Server & Client (Bancos de Dados)"
  ["nap"]="😴 nap (Snippets Manager)"
  ["navi"]="🧭 navi (An interactive cheatsheet tool for the command-line)"
  ["ncspot"]="📦 ncspot (Modern CLI tool)"
  ["neovim"]="📝 Neovim (Editor de texto avançado)"
  ["newsboat"]="📦 newsboat (Modern CLI tool)"
  ["ngrok"]="📦 ngrok (Modern CLI tool)"
  ["nuclei"]="📦 nuclei (Modern CLI tool)"
  ["numbat"]="🧮 numbat (High precision scientific calculator)"
  ["nushell"]="🐚 Nushell (A new type of shell)"
  ["obsidian"]="📓 Obsidian (Second Brain & Notas)"
  ["oha"]="📈 Oha (HTTP Benchmarking)"
  ["ollama"]="🦙 Ollama (Rode LLMs localmente)"
  ["onefetch"]="📊 onefetch (Git Summary)"
  ["open-interpreter"]="🤖 Open-Interpreter (LLMs executando código)"
  ["opentofu"]="🏗️ OpenTofu (Infrastructure as Code)"
  ["ouch"]="🗜️ ouch (Painless compression and decompression)"
  ["oxker"]="📦 oxker (Modern CLI tool)"
  ["oxlint"]="🐂 oxlint (Fast JS/TS linter)"
  ["pastel"]="🎨 pastel (Command-line Color Tool)"
  ["peco"]="📦 peco (Modern CLI tool)"
  ["pipes-rs"]="📦 pipes-rs (Modern CLI tool)"
  ["pipes-sh"]="🚰 pipes-sh (Animated pipes screensaver)"
  ["pkgx"]="📦 pkgx (Blazing fast package manager)"
  ["plandex"]="🤖 Plandex (AI coding engine)"
  ["pnpm"]="📦 pnpm (Fast package manager)"
  ["podman"]="🦭 Podman (Daemonless container engine)"
  ["pokeget"]="📦 pokeget (Modern CLI tool)"
  ["pomsky"]="🐾 pomsky (Regex alternative)"
  ["popeye"]="📦 popeye (Modern CLI tool)"
  ["porsmo"]="📦 porsmo (Modern CLI tool)"
  ["posting"]="📮 Posting (HTTP Client TUI)"
  ["presenterm"]="📽️ presenterm (Markdown presentations in terminal)"
  ["procs"]="🔍 Procs (A modern replacement for ps)"
  ["pueue"]="🗃️ Pueue (Command-line task management tool)"
  ["px"]="📦 px (Modern CLI tool)"
  ["qsv"]="📦 qsv (Modern CLI tool)"
  ["repomix"]="📦 Repomix (Pack repo for AI)"
  ["rip"]="📦 rip (Modern CLI tool)"
  ["ripgrep"]="⚡ Ripgrep (Line-oriented search tool)"
  ["rnr"]="📦 rnr (Modern CLI tool)"
  ["rs-cmatrix"]="📦 rs-cmatrix (Modern CLI tool)"
  ["ruff"]="⚡ Ruff (Extremely fast Python linter)"
  ["ruplacer"]="📦 ruplacer (Modern CLI tool)"
  ["rustscan"]="📦 rustscan (Modern CLI tool)"
  ["rye"]="🌾 Rye (Hassle-free Python experience)"
  ["sad"]="📦 sad (Modern CLI tool)"
  ["scc"]="📦 scc (Modern CLI tool)"
  ["sd"]="🔍 sd (Search & Displace)"
  ["serie"]="📦 serie (Modern CLI tool)"
  ["serpl"]="📦 serpl (Modern CLI tool)"
  ["sesh"]="🖥️ sesh (Smart Session Manager)"
  ["shell-gpt"]="💬 Shell-GPT (ChatGPT from terminal)"
  ["shellcheck"]="📦 shellcheck (Modern CLI tool)"
  ["shfmt"]="📦 shfmt (Modern CLI tool)"
  ["silicon"]="📦 silicon (Modern CLI tool)"
  ["skate"]="📦 skate (Modern CLI tool)"
  ["skim"]="📦 skim (Modern CLI tool)"
  ["slack"]="💬 Slack Desktop (Comunicação)"
  ["slides"]="📦 slides (Modern CLI tool)"
  ["slumber"]="😴 Slumber (Terminal HTTP Client)"
  ["sniffnet"]="🕸️ sniffnet (Network traffic monitor)"
  ["so"]="🔍 so (StackOverflow in terminal)"
  ["sops"]="📦 sops (Modern CLI tool)"
  ["spacer"]="📦 spacer (Modern CLI tool)"
  ["spt"]="📦 spt (Modern CLI tool)"
  ["sqlc"]="📦 sqlc (Modern CLI tool)"
  ["starship"]="🚀 Starship Prompt (Synthwave '84 ativado)"
  ["steampipe"]="📦 steampipe (Modern CLI tool)"
  ["stern"]="📦 stern (Modern CLI tool)"
  ["supabase"]="📦 supabase (Modern CLI tool)"
  ["superfile"]="📁 Superfile (Terminal File Manager)"
  ["syft"]="📦 syft (Modern CLI tool)"
  ["systemctl-tui"]="📦 systemctl-tui (Modern CLI tool)"
  ["systeroid"]="📦 systeroid (Modern CLI tool)"
  ["sysz"]="📦 sysz (Modern CLI tool)"
  ["t-rec"]="📼 t-rec (Blazing fast terminal recorder)"
  ["tailspin"]="🪵 tailspin (Log Highlighter)"
  ["taplo"]="⚙️ taplo (TOML toolkit)"
  ["task"]="✅ task (Modern Make alternative)"
  ["taskwarrior-tui"]="📦 taskwarrior-tui (Modern CLI tool)"
  ["tealdeer"]="🦌 Tealdeer (A very fast implementation of tldr in Rust)"
  ["television"]="📺 television (Blazing fast fuzzy finder)"
  ["tenki"]="📦 tenki (Modern CLI tool)"
  ["tenv"]="📦 tenv (Modern CLI tool)"
  ["termdbms"]="📦 termdbms (Modern CLI tool)"
  ["termscp"]="📁 termscp (Terminal file transfer)"
  ["termshark"]="📦 termshark (Modern CLI tool)"
  ["termtyper"]="📦 termtyper (Modern CLI tool)"
  ["tfsec"]="📦 tfsec (Modern CLI tool)"
  ["tgpt"]="🤖 tgpt (Terminal ChatGPT)"
  ["thefuck"]="📦 thefuck (Modern CLI tool)"
  ["tickrs"]="📦 tickrs (Modern CLI tool)"
  ["tilt"]="📦 tilt (Modern CLI tool)"
  ["tin-summer"]="📦 tin-summer (Modern CLI tool)"
  ["tldr"]="📦 tldr (Modern CLI tool)"
  ["tlrc"]="📚 tlrc (Official tldr client)"
  ["tokei"]="⏰ Tokei (Code Statistics)"
  ["topgrade"]="🚀 topgrade (Upgrade Everything)"
  ["trash-cli"]="🗑️ trash-cli (Safer rm)"
  ["tre"]="📦 tre (Modern CLI tool)"
  ["trippy"]="🗺️ trippy (Network Diagnostic)"
  ["trivy"]="📦 trivy (Modern CLI tool)"
  ["trufflehog"]="📦 trufflehog (Modern CLI tool)"
  ["trzsz"]="📦 trzsz (Modern CLI tool)"
  ["tt"]="📦 tt (Modern CLI tool)"
  ["ttyper"]="📦 ttyper (Modern CLI tool)"
  ["turso"]="📦 turso (Modern CLI tool)"
  ["typos"]="📝 typos (Source code spell checker)"
  ["typst"]="📝 typst (Markup-based typesetting system)"
  ["ugrep"]="📦 ugrep (Modern CLI tool)"
  ["usql"]="📦 usql (Modern CLI tool)"
  ["uv"]="🐍 uv (Gerenciador Python ultrarrápido em Rust)"
  ["vcluster"]="📦 vcluster (Modern CLI tool)"
  ["vegeta"]="📦 vegeta (Modern CLI tool)"
  ["vhs"]="📼 vhs (Terminal GIF Recorder)"
  ["viddy"]="⌚ viddy (Modern watch command)"
  ["visidata"]="📦 visidata (Modern CLI tool)"
  ["viu"]="📦 viu (Modern CLI tool)"
  ["vscode"]="💻 Visual Studio Code (Setup Moderno)"
  ["walk"]="📦 walk (Modern CLI tool)"
  ["warp"]="⚡ Warp Terminal (AI & GPU Acelerado)"
  ["watchexec"]="📦 watchexec (Modern CLI tool)"
  ["websocat"]="🌐 websocat (Command-line client for WebSockets)"
  ["wezterm"]="💻 WezTerm (Emulador de terminal acelerado por GPU)"
  ["wiki-tui"]="📖 wiki-tui (Wikipedia TUI)"
  ["windsurf"]="🏄 Windsurf (AI IDE da Codeium)"
  ["wtfutil"]="🖥️ wtfutil (Personal information dashboard)"
  ["wthrr"]="🌦️ wthrr (Weather crab)"
  ["wuzz"]="📦 wuzz (Modern CLI tool)"
  ["xc"]="📝 xc (Markdown task runner)"
  ["xcp"]="🚀 xcp (Extended cp)"
  ["xh"]="📦 xh (Modern CLI tool)"
  ["xplr"]="📁 xplr (TUI file explorer)"
  ["xsv"]="📊 xsv (High performance CSV toolkit)"
  ["yamlfmt"]="📦 yamlfmt (Modern CLI tool)"
  ["yazi"]="🦆 Yazi File Manager (Arquivos na velocidade da luz)"
  ["yq"]="📦 yq (Modern CLI tool)"
  ["yt-dlp"]="🎥 yt-dlp (Video downloader)"
  ["zed"]="💻 Zed Editor (Escrito em Rust)"
  ["zellij"]="🪟 Zellij Terminal Multiplexer (Workspace Moderno)"
  ["zen-browser"]="🌐 Zen Browser (Navegador ultrarrápido focado em privacidade)"
  ["zenith"]="📈 zenith (System Monitor with Charts)"
  ["zizmor"]="🛡️ zizmor (Static analysis tool for GitHub Actions)"
  ["zoxide"]="🚀 Zoxide (A smarter cd command)"
  ["zrok"]="📦 zrok (Modern CLI tool)"
  ["zsh"]="🐚 Zsh shell e plugins (Hiper-produtividade)"
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

if command -v "$GUM" &> /dev/null; then
  echo ""
  "$GUM" style \
    --foreground "#fede5d" --bold \
    --border double --border-foreground "#ff7edb" \
    --padding "1 2" --margin "1 0" --align center --width 80 \
    "Selecione os módulos que deseja instalar:" \
    "(Use Espaço para marcar/desmarcar, Enter para confirmar)"
  echo ""

  # Prepare choices with descriptions
  CHOICES=()
  for mod in "${ALL_MODULES[@]}"; do
    desc="${MOD_DESC[$mod]:-Módulo $mod}"
    CHOICES+=("$mod - $desc")
  done

  # Prepare comma-separated default modules string with descriptions
  DEFAULTS_DESC=()
  for mod in "${DEFAULT_MODULES[@]}"; do
    desc="${MOD_DESC[$mod]:-Módulo $mod}"
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
    --selected.foreground="#36f9f6" \
    --cursor.foreground="#ff7edb" \
    --item.foreground="#f8f8f2" \
    --header="🚀 Selecione os módulos (pressione '/' para buscar):" \
    --header.foreground="#fede5d" \
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
      desc="${MOD_DESC[$mod]:-Módulo $mod}"
      MOD_LIST+="  $($GUM style --foreground "#ff7edb" "•") $($GUM style --foreground "#fede5d" "$mod") $($GUM style --foreground "#6272a4" "($desc)")"$'\n'
    fi
  done
  # Use gum join to create columns if there are many modules
  if [ ${#MODULES[@]} -gt 80 ]; then
    FIFTH=$((${#MODULES[@]} / 5 + 1))
    COL1=$(echo -e "$MOD_LIST" | head -n $FIFTH)
    COL2=$(echo -e "$MOD_LIST" | tail -n +$((FIFTH + 1)) | head -n $FIFTH)
    COL3=$(echo -e "$MOD_LIST" | tail -n +$((2 * FIFTH + 1)) | head -n $FIFTH)
    COL4=$(echo -e "$MOD_LIST" | tail -n +$((3 * FIFTH + 1)) | head -n $FIFTH)
    COL5=$(echo -e "$MOD_LIST" | tail -n +$((4 * FIFTH + 1)))
    echo "$("$GUM" join --horizontal "$COL1" "  " "$COL2" "  " "$COL3" "  " "$COL4" "  " "$COL5")" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
  elif [ ${#MODULES[@]} -gt 60 ]; then
    QUARTER=$((${#MODULES[@]} / 4 + 1))
    COL1=$(echo -e "$MOD_LIST" | head -n $QUARTER)
    COL2=$(echo -e "$MOD_LIST" | tail -n +$((QUARTER + 1)) | head -n $QUARTER)
    COL3=$(echo -e "$MOD_LIST" | tail -n +$((2 * QUARTER + 1)) | head -n $QUARTER)
    COL4=$(echo -e "$MOD_LIST" | tail -n +$((3 * QUARTER + 1)))
    echo "$("$GUM" join --horizontal "$COL1" "  " "$COL2" "  " "$COL3" "  " "$COL4")" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
  elif [ ${#MODULES[@]} -gt 30 ]; then
    THIRD=$((${#MODULES[@]} / 3 + 1))
    COL1=$(echo -e "$MOD_LIST" | head -n $THIRD)
    COL2=$(echo -e "$MOD_LIST" | tail -n +$((THIRD + 1)) | head -n $THIRD)
    COL3=$(echo -e "$MOD_LIST" | tail -n +$((2 * THIRD + 1)))
    echo "$("$GUM" join --horizontal "$COL1" "  " "$COL2" "  " "$COL3")" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
  elif [ ${#MODULES[@]} -gt 15 ]; then
    HALF=$((${#MODULES[@]} / 2 + 1))
    COL1=$(echo -e "$MOD_LIST" | head -n $HALF)
    COL2=$(echo -e "$MOD_LIST" | tail -n +$((HALF + 1)))
    echo "$("$GUM" join --horizontal "$COL1" "  " "$COL2")" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
  else
    echo -e "$MOD_LIST" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
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

if [[ "$DRY_RUN" == false ]]; then
  if command -v "$GUM" &> /dev/null; then
    SUMMARY_BOX=$("$GUM" style \
      --foreground "#f8f8f2" --border-foreground "#ff7edb" --border double \
      --align center --width 65 --margin "2 2" --padding "2 4" \
      "🚀 $($GUM style --foreground "#fede5d" --bold "RESUMO DA INSTALAÇÃO") 🚀" \
      "" \
      "Perfil: $($GUM style --foreground "#36f9f6" --bold "$PROFILE")" \
      "Total de Módulos: $($GUM style --foreground "#72f1b8" --bold "${#MODULES[@]}")")
    echo "$SUMMARY_BOX"
    echo ""
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
  else
    echo "Resumo da Instalação:"
    echo "Perfil: $PROFILE"
    echo "Total de Módulos: ${#MODULES[@]}"
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
  if command -v "$GUM" &> /dev/null; then
    "$GUM" style --foreground "#bd93f9" -- "----------------------------------------"
  fi
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