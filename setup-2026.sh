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
      --cursor="🚀 " \
      --header="Escolha o seu nível de poder no Nexus:" \
      --header.foreground="#ff7edb" \
      --header.bold \
      --cursor.foreground="#72f1b8" \
      --cursor.bold \
      --item.foreground="#f8f8f2" \
      --selected.foreground="#36f9f6" \
      --selected.bold \
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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship vscode sd choose gobang bottom macchina xplr circumflex lsd)
    ;;
  dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd)
    ;;
  full)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric fastfetch fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum harlequin hck helix helm hexyl howdoi htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugrep usql uv vcluster vegeta vhs viddy visidata viu vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp lazygit lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s posting superfile aider plandex open-interpreter duckdb harlequin fastfetch lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd)
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
  ["age"]="📦 age (A simple, modern and secure file encryption tool)"
  ["aichat"]="💬 aichat (AI Chat)"
  ["aider"]="🤖 Aider-chat (AI pair programming)"
  ["amber"]="🔍 amber (Search & Replace)"
  ["android"]="📱 Android Studio & SDK (Plataforma Mobile)"
  ["ast-grep"]="🌳 ast-grep (AST based search/replace)"
  ["atac"]="🚀 Atac (Modern API Client TUI)"
  ["atlas"]="📦 atlas (Modern tool for managing database schemas)"
  ["atuin"]="🐢 Atuin (Magical Shell History)"
  ["bacon"]="🥓 bacon (Background Rust code checker)"
  ["bandwhich"]="📈 bandwhich (Bandwidth Monitor)"
  ["bat"]="🦇 Bat (A cat clone with wings)"
  ["bat-extras"]="🦇 bat-extras (Bash scripts that integrate bat with various command line tools)"
  ["binsider"]="📦 binsider (Ferramenta CLI moderna)"
  ["biome"]="🚀 Biome (Fast JS/TS toolchain)"
  ["bluetuith"]="📦 bluetuith (Ferramenta CLI moderna)"
  ["bore-cli"]="📦 bore-cli (Ferramenta CLI moderna)"
  ["bottom"]="📈 bottom (System Monitor)"
  ["brave"]="🦁 Brave (Navegador focado em privacidade)"
  ["broot"]="🌲 Broot (A new way to see and navigate directory trees)"
  ["bruno"]="🐶 Bruno (API Client open-source e leve)"
  ["btop"]="📊 Btop (A monitor of resources)"
  ["bun"]="🥟 Bun JavaScript runtime (Ultrarrápido)"
  ["carapace"]="🐚 carapace (Multi-shell Completer)"
  ["cbonsai"]="🌲 cbonsai (Terminal bonsai tree)"
  ["chafa"]="📦 chafa (Ferramenta CLI moderna)"
  ["charm"]="📦 charm (Ferramenta CLI moderna)"
  ["chatbox"]="💬 Chatbox (Copilot for your desktop)"
  ["chatgpt-cli"]="📦 chatgpt-cli (Ferramenta CLI moderna)"
  ["cheat"]="📦 cheat (Ferramenta CLI moderna)"
  ["checkov"]="📦 checkov (Ferramenta CLI moderna)"
  ["choose"]="✂️ choose (Human-friendly cut)"
  ["circumflex"]="📰 circumflex (Hacker News in terminal)"
  ["claude-code"]="🤖 Claude Code (AI Assistant CLI da Anthropic)"
  ["cli-tools"]="🧰 O Arsenal Definitivo 2026 (Ferramentas CLI)"
  ["cline"]="🤖 Cline (Autonomous coding agent CLI)"
  ["cloudflared"]="📦 cloudflared (Ferramenta CLI moderna)"
  ["cocogitto"]="📦 cocogitto (Ferramenta CLI moderna)"
  ["code2prompt"]="📝 code2prompt (Convert codebase to LLM prompt)"
  ["cointop"]="🪙 cointop (Crypto tracker)"
  ["common"]="⚙️ Scripts compartilhados e helpers"
  ["cpufetch"]="📦 cpufetch (Ferramenta CLI moderna)"
  ["crane"]="📦 crane (Ferramenta CLI moderna)"
  ["croc"]="🐊 croc (Securely send things between computers)"
  ["csvlens"]="📊 csvlens (CSV viewer)"
  ["ctop"]="📦 ctop (Ferramenta CLI moderna)"
  ["curlie"]="🦱 Curlie (curl + httpie)"
  ["cursor"]="🤖 Cursor AI Code Editor (Futuro do código)"
  ["czg"]="📦 czg (Ferramenta CLI moderna)"
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
  ["direnv"]="📦 direnv (Ferramenta CLI moderna)"
  ["discord"]="🎮 Discord (Comunicação de voz e texto)"
  ["diskonaut"]="📦 diskonaut (Ferramenta CLI moderna)"
  ["distrobox"]="📦 Distrobox (Run any linux distro in terminal)"
  ["dive"]="🐳 dive (Docker image explorer)"
  ["docker"]="🐳 Docker Engine (Contêineres)"
  ["doggo"]="🐶 Doggo (Modern DNS Client)"
  ["dolt"]="📦 dolt (Ferramenta CLI moderna)"
  ["dotenv-linter"]="📦 dotenv-linter (Ferramenta CLI moderna)"
  ["dotenvx"]="📦 dotenvx (Ferramenta CLI moderna)"
  ["dprint"]="📦 dprint (Ferramenta CLI moderna)"
  ["dsq"]="🗃️ dsq (SQL for JSON, CSV, etc.)"
  ["dua"]="💽 dua (Disk Usage Analyzer)"
  ["dua-cli"]="📦 dua-cli (Ferramenta CLI moderna)"
  ["duckdb"]="🦆 DuckDB (In-process SQL OLAP DBMS)"
  ["duf"]="📦 duf (Ferramenta CLI moderna)"
  ["dufs"]="📁 dufs (Utility file server)"
  ["dura"]="📦 dura (Ferramenta CLI moderna)"
  ["dust"]="🌪️ dust (A more intuitive version of du in rust)"
  ["dysk"]="📦 dysk (Ferramenta CLI moderna)"
  ["earthly"]="📦 earthly (Ferramenta CLI moderna)"
  ["eget"]="📦 eget (Ferramenta CLI moderna)"
  ["erdtree"]="🌳 erdtree (File-tree Visualizer)"
  ["evans"]="📦 evans (Ferramenta CLI moderna)"
  ["eza"]="🌟 Eza (A modern, maintained replacement for ls)"
  ["fabric"]="🤖 fabric (AI CLI framework)"
  ["fastfetch"]="⚡ Fastfetch (Modern System Info)"
  ["fd-find"]="📂 fd (A simple, fast and user-friendly alternative to find)"
  ["fend"]="🧮 fend (Arbitrary-precision unit-aware calculator)"
  ["firefox"]="🦊 Navegador Firefox (Otimizado)"
  ["flox"]="❄️ Flox (Developer environments for everyone)"
  ["flyctl"]="📦 flyctl (Ferramenta CLI moderna)"
  ["fnm"]="🐢 fnm (Fast Node Manager)"
  ["fq"]="📦 fq (Ferramenta CLI moderna)"
  ["freeze"]="📦 freeze (Ferramenta CLI moderna)"
  ["fx"]="📦 fx (Ferramenta CLI moderna)"
  ["fzf"]="🔍 Fzf (A command-line fuzzy finder)"
  ["gcloud"]="📦 gcloud (Ferramenta CLI moderna)"
  ["gdu"]="📊 gdu (Disk usage analyzer)"
  ["genact"]="📦 genact (Ferramenta CLI moderna)"
  ["gh"]="🐙 gh (GitHub CLI)"
  ["gh-dash"]="📦 gh-dash (Ferramenta CLI moderna)"
  ["ghostty"]="👻 Ghostty (Emulador de Terminal Ultrarrápido)"
  ["ghq"]="📦 ghq (Ferramenta CLI moderna)"
  ["git-absorb"]="📦 git-absorb (Ferramenta CLI moderna)"
  ["git-cliff"]="⛰️ git-cliff (Changelog Generator)"
  ["git-filter-repo"]="📦 git-filter-repo (Ferramenta CLI moderna)"
  ["git-sim"]="📦 git-sim (Ferramenta CLI moderna)"
  ["git-town"]="📦 git-town (Ferramenta CLI moderna)"
  ["gitingest"]="🧠 Gitingest (Git to AI prompt)"
  ["gitleaks"]="🔐 gitleaks (Secret scanner for git)"
  ["gitui"]="🐙 GitUI (Blazing Fast Git TUI)"
  ["glab"]="📦 glab (Ferramenta CLI moderna)"
  ["glances"]="👀 glances (System monitor)"
  ["glow"]="🌟 Glow (Markdown Renderer)"
  ["gobang"]="🗃️ gobang (Cross-platform Database Client TUI)"
  ["gojq"]="📦 gojq (Ferramenta CLI moderna)"
  ["gping"]="🏓 gping (Ping, but with a graph)"
  ["grex"]="🧠 grex (Regex Generator)"
  ["gron"]="🔧 gron (Make JSON greppable)"
  ["grpcurl"]="📦 grpcurl (Ferramenta CLI moderna)"
  ["grype"]="📦 grype (Ferramenta CLI moderna)"
  ["gtt"]="📦 gtt (Ferramenta CLI moderna)"
  ["gum"]="📦 gum (Ferramenta CLI moderna)"
  ["harlequin"]="🎩 Harlequin (SQL IDE for terminal)"
  ["hck"]="📦 hck (A sharp cut(1) clone)"
  ["helix"]="🧬 Helix (Post-modern text editor)"
  ["helm"]="📦 helm (Ferramenta CLI moderna)"
  ["hexyl"]="🔢 hexyl (Hex viewer)"
  ["howdoi"]="📦 howdoi (Ferramenta CLI moderna)"
  ["htmlq"]="📦 htmlq (Ferramenta CLI moderna)"
  ["httpie"]="📦 httpie (Ferramenta CLI moderna)"
  ["httpstat"]="📦 httpstat (Ferramenta CLI moderna)"
  ["httpx"]="📦 httpx (Ferramenta CLI moderna)"
  ["hurl"]="📦 hurl (Ferramenta CLI moderna)"
  ["hwatch"]="📦 hwatch (Ferramenta CLI moderna)"
  ["hyperfine"]="⏱️ Hyperfine (A command-line benchmarking tool)"
  ["igrep"]="📦 igrep (Ferramenta CLI moderna)"
  ["infracost"]="📦 infracost (Ferramenta CLI moderna)"
  ["inlyne"]="🖥️ inlyne (GPU powered markdown viewer)"
  ["inshellisense"]="💡 Inshellisense (IDE style autocomplete for shells)"
  ["jan"]="🤖 Jan (Local AI alternative to ChatGPT)"
  ["jaq"]="📦 jaq (Ferramenta CLI moderna)"
  ["jc"]="📦 jc (Ferramenta CLI moderna)"
  ["jira-cli"]="📦 jira-cli (Ferramenta CLI moderna)"
  ["jj"]="🐙 jj (Git alternative)"
  ["jless"]="🔍 Jless (JSON Viewer)"
  ["jnv"]="📦 jnv (Ferramenta CLI moderna)"
  ["jo"]="🔧 jo (JSON output utility)"
  ["joshuto"]="📁 joshuto (Terminal file manager)"
  ["jq"]="📦 jq (Ferramenta CLI moderna)"
  ["jql"]="📦 jql (Ferramenta CLI moderna)"
  ["jqp"]="📦 jqp (Ferramenta CLI moderna)"
  ["jujutsu"]="📦 jujutsu (Ferramenta CLI moderna)"
  ["just"]="🤖 Just (Command Runner)"
  ["k3d"]="📦 k3d (Ferramenta CLI moderna)"
  ["k6"]="🚀 k6 (Modern load testing tool)"
  ["k8sgpt"]="☸️ k8sgpt (AI for Kubernetes)"
  ["k9s"]="🐶 k9s (Kubernetes CLI TUI)"
  ["kalker"]="📦 kalker (Ferramenta CLI moderna)"
  ["kdash"]="☸️ kdash (Kubernetes Dashboard)"
  ["kind"]="📦 kind (Ferramenta CLI moderna)"
  ["klog"]="📦 klog (Ferramenta CLI moderna)"
  ["kmon"]="🐧 kmon (Linux Kernel Manager and Activity Monitor)"
  ["ko"]="📦 ko (Ferramenta CLI moderna)"
  ["kondo"]="🧹 kondo (Clean up software projects)"
  ["krew"]="📦 krew (Ferramenta CLI moderna)"
  ["kubecolor"]="📦 kubecolor (Ferramenta CLI moderna)"
  ["kubectl"]="📦 kubectl (Ferramenta CLI moderna)"
  ["kubectx"]="📦 kubectx (Ferramenta CLI moderna)"
  ["kustomize"]="📦 kustomize (Ferramenta CLI moderna)"
  ["lazydocker"]="🐳 LazyDocker TUI (Contêineres com Estilo)"
  ["lazygit"]="🐙 LazyGit TUI (Git feito certo)"
  ["lazynpm"]="📦 Lazynpm (NPM TUI)"
  ["lazysql"]="🦥 Lazysql (SQL Client TUI)"
  ["lefthook"]="📦 lefthook (Ferramenta CLI moderna)"
  ["lf"]="📦 lf (Ferramenta CLI moderna)"
  ["llm"]="🧠 LLM (Access Large Language Models)"
  ["lmstudio"]="🧠 LM Studio (Rode LLMs locais com interface gráfica)"
  ["lnav"]="📦 lnav (Ferramenta CLI moderna)"
  ["lsd"]="🌟 lsd (Modern ls replacement)"
  ["lychee"]="📦 lychee (Ferramenta CLI moderna)"
  ["macchina"]="💻 macchina (System information fetcher)"
  ["mani"]="📦 mani (Ferramenta CLI moderna)"
  ["mcfly"]="📦 mcfly (Ferramenta CLI moderna)"
  ["mdcat"]="📦 mdcat (Ferramenta CLI moderna)"
  ["melt"]="📦 melt (Ferramenta CLI moderna)"
  ["miller"]="📦 miller (Ferramenta CLI moderna)"
  ["miniserve"]="🗄️ miniserve (Fast local file server)"
  ["mise"]="🛠️ Mise (Polyglot Tool Version Manager)"
  ["mkcert"]="📦 mkcert (Ferramenta CLI moderna)"
  ["moar"]="📄 moar (Better Pager)"
  ["mods"]="🤖 Mods (AI on the command line)"
  ["monolith"]="📦 monolith (Ferramenta CLI moderna)"
  ["moon"]="🌙 Moon (Build system for JS/TS)"
  ["mprocs"]="🔄 mprocs (Run multiple commands in parallel)"
  ["mysql"]="🐬 MySQL Server & Client (Bancos de Dados)"
  ["nap"]="😴 nap (Snippets Manager)"
  ["navi"]="🧭 navi (An interactive cheatsheet tool for the command-line)"
  ["ncspot"]="📦 ncspot (Ferramenta CLI moderna)"
  ["neovim"]="📝 Neovim (Editor de texto avançado)"
  ["newsboat"]="📦 newsboat (Ferramenta CLI moderna)"
  ["ngrok"]="📦 ngrok (Ferramenta CLI moderna)"
  ["nuclei"]="📦 nuclei (Ferramenta CLI moderna)"
  ["numbat"]="🧮 numbat (High precision scientific calculator)"
  ["nushell"]="🐚 Nushell (A new type of shell)"
  ["obsidian"]="📓 Obsidian (Second Brain & Notas)"
  ["oha"]="📈 Oha (HTTP Benchmarking)"
  ["ollama"]="🦙 Ollama (Rode LLMs localmente)"
  ["onefetch"]="📊 onefetch (Git Summary)"
  ["open-interpreter"]="🤖 Open-Interpreter (LLMs executando código)"
  ["opentofu"]="🏗️ OpenTofu (Infrastructure as Code)"
  ["ouch"]="🗜️ ouch (Painless compression and decompression)"
  ["oxker"]="📦 oxker (Ferramenta CLI moderna)"
  ["oxlint"]="🐂 oxlint (Fast JS/TS linter)"
  ["pastel"]="🎨 pastel (Command-line Color Tool)"
  ["peco"]="📦 peco (Ferramenta CLI moderna)"
  ["pipes-rs"]="📦 pipes-rs (Ferramenta CLI moderna)"
  ["pipes-sh"]="🚰 pipes-sh (Animated pipes screensaver)"
  ["pkgx"]="📦 pkgx (Blazing fast package manager)"
  ["plandex"]="🤖 Plandex (AI coding engine)"
  ["pnpm"]="📦 pnpm (Fast package manager)"
  ["podman"]="🦭 Podman (Daemonless container engine)"
  ["pokeget"]="📦 pokeget (Ferramenta CLI moderna)"
  ["pomsky"]="🐾 pomsky (Regex alternative)"
  ["popeye"]="📦 popeye (Ferramenta CLI moderna)"
  ["porsmo"]="📦 porsmo (Ferramenta CLI moderna)"
  ["posting"]="📮 Posting (HTTP Client TUI)"
  ["presenterm"]="📽️ presenterm (Markdown presentations in terminal)"
  ["procs"]="🔍 Procs (A modern replacement for ps)"
  ["pueue"]="🗃️ Pueue (Command-line task management tool)"
  ["px"]="📦 px (Ferramenta CLI moderna)"
  ["qsv"]="📦 qsv (Ferramenta CLI moderna)"
  ["repomix"]="📦 Repomix (Pack repo for AI)"
  ["rip"]="📦 rip (Ferramenta CLI moderna)"
  ["ripgrep"]="⚡ Ripgrep (Line-oriented search tool)"
  ["rnr"]="📦 rnr (Ferramenta CLI moderna)"
  ["rs-cmatrix"]="📦 rs-cmatrix (Ferramenta CLI moderna)"
  ["ruff"]="⚡ Ruff (Extremely fast Python linter)"
  ["ruplacer"]="📦 ruplacer (Ferramenta CLI moderna)"
  ["rustscan"]="📦 rustscan (Ferramenta CLI moderna)"
  ["rye"]="🌾 Rye (Hassle-free Python experience)"
  ["sad"]="📦 sad (Ferramenta CLI moderna)"
  ["scc"]="📦 scc (Ferramenta CLI moderna)"
  ["sd"]="🔍 sd (Search & Displace)"
  ["serie"]="📦 serie (Ferramenta CLI moderna)"
  ["serpl"]="📦 serpl (Ferramenta CLI moderna)"
  ["sesh"]="🖥️ sesh (Smart Session Manager)"
  ["shell-gpt"]="💬 Shell-GPT (ChatGPT from terminal)"
  ["shellcheck"]="📦 shellcheck (Ferramenta CLI moderna)"
  ["shfmt"]="📦 shfmt (Ferramenta CLI moderna)"
  ["silicon"]="📦 silicon (Ferramenta CLI moderna)"
  ["skate"]="📦 skate (Ferramenta CLI moderna)"
  ["skim"]="📦 skim (Ferramenta CLI moderna)"
  ["slack"]="💬 Slack Desktop (Comunicação)"
  ["slides"]="📦 slides (Ferramenta CLI moderna)"
  ["slumber"]="😴 Slumber (Terminal HTTP Client)"
  ["sniffnet"]="🕸️ sniffnet (Network traffic monitor)"
  ["so"]="🔍 so (StackOverflow in terminal)"
  ["sops"]="📦 sops (Ferramenta CLI moderna)"
  ["spacer"]="📦 spacer (Ferramenta CLI moderna)"
  ["spt"]="📦 spt (Ferramenta CLI moderna)"
  ["sqlc"]="📦 sqlc (Ferramenta CLI moderna)"
  ["starship"]="🚀 Starship Prompt (Synthwave '84 ativado)"
  ["steampipe"]="📦 steampipe (Ferramenta CLI moderna)"
  ["stern"]="📦 stern (Ferramenta CLI moderna)"
  ["supabase"]="📦 supabase (Ferramenta CLI moderna)"
  ["superfile"]="📁 Superfile (Terminal File Manager)"
  ["syft"]="📦 syft (Ferramenta CLI moderna)"
  ["systemctl-tui"]="📦 systemctl-tui (Ferramenta CLI moderna)"
  ["systeroid"]="📦 systeroid (Ferramenta CLI moderna)"
  ["sysz"]="📦 sysz (Ferramenta CLI moderna)"
  ["t-rec"]="📼 t-rec (Blazing fast terminal recorder)"
  ["tailspin"]="🪵 tailspin (Log Highlighter)"
  ["taplo"]="⚙️ taplo (TOML toolkit)"
  ["task"]="✅ task (Modern Make alternative)"
  ["taskwarrior-tui"]="📦 taskwarrior-tui (Ferramenta CLI moderna)"
  ["tealdeer"]="🦌 Tealdeer (A very fast implementation of tldr in Rust)"
  ["television"]="📺 television (Blazing fast fuzzy finder)"
  ["tenki"]="⛅ tenki (Weather in terminal)"
  ["tenv"]="📦 tenv (Ferramenta CLI moderna)"
  ["termdbms"]="📦 termdbms (Ferramenta CLI moderna)"
  ["termscp"]="📁 termscp (Terminal file transfer)"
  ["termshark"]="📦 termshark (Ferramenta CLI moderna)"
  ["termtyper"]="📦 termtyper (Ferramenta CLI moderna)"
  ["tfsec"]="📦 tfsec (Ferramenta CLI moderna)"
  ["tgpt"]="🤖 tgpt (Terminal ChatGPT)"
  ["thefuck"]="📦 thefuck (Ferramenta CLI moderna)"
  ["tickrs"]="📈 tickrs (Real-time ticker data in terminal)"
  ["tilt"]="📦 tilt (Ferramenta CLI moderna)"
  ["tin-summer"]="📦 tin-summer (Ferramenta CLI moderna)"
  ["tldr"]="📦 tldr (Ferramenta CLI moderna)"
  ["tlrc"]="📚 tlrc (Official tldr client)"
  ["tokei"]="⏰ Tokei (Code Statistics)"
  ["topgrade"]="🚀 topgrade (Upgrade Everything)"
  ["trash-cli"]="🗑️ trash-cli (Safer rm)"
  ["tre"]="📦 tre (Ferramenta CLI moderna)"
  ["trippy"]="🗺️ trippy (Network Diagnostic)"
  ["trivy"]="📦 trivy (Ferramenta CLI moderna)"
  ["trufflehog"]="📦 trufflehog (Ferramenta CLI moderna)"
  ["trzsz"]="📦 trzsz (Ferramenta CLI moderna)"
  ["tt"]="📦 tt (Ferramenta CLI moderna)"
  ["ttyper"]="📦 ttyper (Ferramenta CLI moderna)"
  ["turso"]="📦 turso (Ferramenta CLI moderna)"
  ["typos"]="📝 typos (Source code spell checker)"
  ["typst"]="📝 typst (Markup-based typesetting system)"
  ["ugrep"]="📦 ugrep (Ferramenta CLI moderna)"
  ["usql"]="📦 usql (Ferramenta CLI moderna)"
  ["uv"]="🐍 uv (Gerenciador Python ultrarrápido em Rust)"
  ["vcluster"]="📦 vcluster (Ferramenta CLI moderna)"
  ["vegeta"]="📦 vegeta (Ferramenta CLI moderna)"
  ["vhs"]="📼 vhs (Terminal GIF Recorder)"
  ["viddy"]="⌚ viddy (Modern watch command)"
  ["visidata"]="📦 visidata (Ferramenta CLI moderna)"
  ["viu"]="📦 viu (Ferramenta CLI moderna)"
  ["vscode"]="💻 Visual Studio Code (Setup Moderno)"
  ["walk"]="📦 walk (Ferramenta CLI moderna)"
  ["warp"]="⚡ Warp Terminal (AI & GPU Acelerado)"
  ["watchexec"]="📦 watchexec (Ferramenta CLI moderna)"
  ["websocat"]="🌐 websocat (Command-line client for WebSockets)"
  ["wezterm"]="💻 WezTerm (Emulador de terminal acelerado por GPU)"
  ["wiki-tui"]="📖 wiki-tui (Wikipedia TUI)"
  ["windsurf"]="🏄 Windsurf (AI IDE da Codeium)"
  ["wtfutil"]="🖥️ wtfutil (Personal information dashboard)"
  ["wthrr"]="🌦️ wthrr (Weather crab)"
  ["wuzz"]="📦 wuzz (Ferramenta CLI moderna)"
  ["xc"]="📝 xc (Markdown task runner)"
  ["xcp"]="🚀 xcp (Extended cp)"
  ["xh"]="📦 xh (Ferramenta CLI moderna)"
  ["xplr"]="📁 xplr (TUI file explorer)"
  ["xsv"]="📊 xsv (High performance CSV toolkit)"
  ["yamlfmt"]="📦 yamlfmt (Ferramenta CLI moderna)"
  ["yazi"]="🦆 Yazi File Manager (Arquivos na velocidade da luz)"
  ["yq"]="📦 yq (Ferramenta CLI moderna)"
  ["yt-dlp"]="🎥 yt-dlp (Video downloader)"
  ["zed"]="💻 Zed Editor (Escrito em Rust)"
  ["zellij"]="🪟 Zellij Terminal Multiplexer (Workspace Moderno)"
  ["zen-browser"]="🌐 Zen Browser (Navegador ultrarrápido focado em privacidade)"
  ["zenith"]="📈 zenith (System Monitor with Charts)"
  ["zizmor"]="🛡️ zizmor (Static analysis tool for GitHub Actions)"
  ["zoxide"]="🚀 Zoxide (A smarter cd command)"
  ["zrok"]="🔗 zrok (Open source ngrok alternative)"
  ["ripgrep_all"]="📦 ripgrep_all (rga - search PDFs, E-Books, Office docs)"
  ["kubens"]="📦 kubens (Kubernetes context switching)"
  ["zsh"]="🐚 Zsh shell e plugins (Hiper-produtividade)"
  ["nix"]="❄️ Nix (Modern package manager)"
  ["gleam"]="✨ Gleam (Type safe programming language)"
  ["elixir"]="💧 Elixir (Dynamic, functional language for building scalable and maintainable applications)"
  ["zig"]="⚡ Zig (Modern programming language)"

  ["doppler"]="🔐 Doppler (SecretOps Platform)"
  ["infisical"]="🔐 Infisical (Open Source Secret Management)"
  ["stripe"]="💳 Stripe CLI (Ferramenta CLI moderna)"
  ["awscli"]="☁️ AWS CLI (Ferramenta CLI moderna)"
  ["vercel"]="▲ Vercel CLI (Ferramenta CLI moderna)"
  ["pulumi"]="🏗️ Pulumi (Infrastructure as Code)"
  ["terragrunt"]="🏗️ Terragrunt (Thin wrapper for Terraform)"
  ["tflint"]="🔍 TFLint (Terraform linter)"
  ["ttyd"]="🌐 ttyd (Share your terminal over the web)"
  ["argc"]="🐚 argc (A bash CLI framework)"

  ["argocd"]="🐙 ArgoCD (Declarative GitOps for K8s)"
  ["k3s"]="☸️ k3s (Lightweight Kubernetes)"
  ["vault"]="🔐 Vault (Manage Secrets and Protect Sensitive Data)"

  ["bw"]="🔐 Bitwarden CLI (Password Manager)"
  ["netlify"]="▲ Netlify CLI (Deploy and manage sites)"
  ["heroku"]="☁️ Heroku CLI (Manage Heroku apps)"
  ["consul"]="🌐 Consul (Service Networking)"
  ["nomad"]="🚀 Nomad (Workload Orchestrator)"
  ["packer"]="📦 Packer (Build Automated Machine Images)"
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
  # Remove trailing newline for cleaner tailing
  MOD_LIST="${MOD_LIST%$'\n'}"

  # Dynamically calculate columns based on module count
  num_mods=${#MODULES[@]}
  if [ $num_mods -gt 80 ]; then cols=5;
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
    echo "$("$GUM" join --horizontal "${join_args[@]}")" | "$GUM" style --border double --margin "0 2" --padding "1 2" --border-foreground "#36f9f6"
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