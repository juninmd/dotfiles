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
      --cursor="⚡ " \
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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship sd choose gobang bottom macchina xplr circumflex lsd lazydocker lazygit-tui k9s-cli posting aider fastfetch)
    ;;
  dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit-tui lazydocker ghostty zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aichat duckdb lazysql harlequin fastfetch)
    ;;
  full)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce fastfetch kew gaze dnote)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp ghostty lazygit-tui lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s-cli posting superfile aider plandex open-interpreter duckdb harlequin neofetch-alt lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aider-chat trippy onefetch grex bandwhich amber tailspin erdtree dua oxlint difftastic topgrade pastel numbat dufs jj sesh carapace moar vhs gitleaks xc gdu trash-cli yt-dlp glances d2 pnpm fnm gping kondo presenterm hexyl csvlens pomsky bacon wiki-tui ast-grep dive gron viddy wtfutil cointop dasel dust navi delta websocat ouch zenith git-cliff typos fend joshuto sniffnet termscp wthrr miniserve zizmor inlyne so xcp taplo tlrc typst xsv gh act task croc dbmate ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next gptme ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce tmux htop cmatrix vivid hadolint ugit pgcli mycli litecli tere kubent lazyvim oh-my-posh micro nnn tig ncdu kakoune hck termshark kmon poetry fastfetch)
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
  ["kew"]="🎵 kew (Command-line music player)"
  ["gaze"]="👀 gaze (Run a command when files change)"
  ["dnote"]="📝 dnote (A simple command line notebook)"

  ["act"]="🎭 act (Run GitHub Actions Locally)"
  ["actionlint"]="📦 actionlint (Static checker for GitHub Actions workflow files)"
  ["age"]="📦 age (Criptografia moderna de arquivos)"
  ["aichat"]="💬 aichat (AI Chat)"
  ["aider"]="🤖 Aider-chat (AI pair programming)"
  ["aider-chat"]="🤖 Aider-chat (AI pair programming)"
  ["amber"]="🔍 amber (Search & Replace)"
  ["android"]="📱 Android Studio & SDK (Plataforma Mobile)"
  ["aqua"]="💧 aqua (Declarative CLI Version Manager)"
  ["argc"]="🐚 argc (Um framework CLI para bash)"
  ["argocd"]="🐙 ArgoCD (Declarative GitOps for K8s)"
  ["ast-grep"]="🌳 ast-grep (AST based search replace)"
  ["atac"]="🚀 Atac (Cliente de API TUI)"
  ["atlas"]="📦 atlas (Gerenciador moderno de esquemas de banco de dados)"
  ["atuin"]="🐢 Atuin (Magical Shell History)"
  ["awscli"]="☁️ AWS CLI (Amazon Web Services CLI)"
  ["bacon"]="🥓 bacon (Background Rust code checker)"
  ["bandwhich"]="📈 bandwhich (Monitor de banda)"
  ["bat"]="🦇 bat (Substituto moderno para o cat com syntax highlighting)"
  ["bat-extras"]="🦇 bat-extras (Scripts bash que integram bat com utilitários cli)"
  ["binsider"]="🔍 binsider (Analisador de binários ELF)"
  ["biome"]="🚀 Biome (Conjunto de utilitários rápidos JS/TS)"
  ["bito"]="🤖 bito (CLI assistente de IA)"
  ["bluetuith"]="🦷 bluetuith (Bluetooth manager TUI)"
  ["bore-cli"]="🚇 bore-cli (Local tunneling)"
  ["bottom"]="📈 bottom (Monitor de sistema TUI)"
  ["boundary"]="🛡️ boundary (Identity-based access management)"
  ["brave"]="🦁 Brave (Navegador focado em privacidade)"
  ["broot"]="🌲 broot (Navegação moderna em árvores de diretórios)"
  ["bruno"]="🐶 Bruno (API Client open-source e leve)"
  ["bruno-cli"]="🐶 bruno-cli (API Client CLI)"
  ["btop"]="📊 btop (Monitor de recursos de sistema)"
  ["bun"]="🥟 Bun JavaScript runtime (Ultrarrápido)"
  ["bw"]="🔐 Bitwarden CLI (Password Manager)"
  ["carapace"]="🐚 carapace (Autocompletar multi-shell)"
  ["cbonsai"]="🌲 cbonsai (Bonsai TUI generator)"
  ["chafa"]="🎨 chafa (Terminal graphics)"
  ["charm"]="✨ charm (Utilitário Charmbracelet)"
  ["chatbox"]="💬 Chatbox (Copilot for your desktop)"
  ["chatgpt-cli"]="🤖 chatgpt-cli (ChatGPT in terminal)"
  ["cheat"]="📄 cheat (Interactive cheatsheets)"
  ["checkov"]="🛡️ checkov (IaC scanner)"
  ["choose"]="✂️ choose (Alternativa moderna para o cut)"
  ["circumflex"]="📰 circumflex (Hacker News no terminal TUI)"
  ["claude-code"]="🤖 Claude Code (AI Assistant CLI da Anthropic)"
  ["cli-tools"]="🧰 Dependências Base (Rust Go Python build-utils)"
  ["cline"]="🤖 Cline (Autonomous coding agent CLI)"
  ["cloudflared"]="☁️ cloudflared (Cliente Cloudflare Tunnel)"
  ["cmatrix"]="💻 cmatrix (Classic Matrix terminal effect)"
  ["cocogitto"]="⚙️ cocogitto (CLI para conventional commits)"
  ["code2prompt"]="📝 code2prompt (Converte base de código para prompt LLM)"
  ["cointop"]="🪙 cointop (Rastreador de criptomoedas TUI)"
  ["common"]="⚙️ Scripts compartilhados e helpers"
  ["consul"]="🌐 Consul (Service Networking)"
  ["cpufetch"]="💻 cpufetch (CPU architecture fetching)"
  ["crane"]="🏗️ crane (Container image interaction)"
  ["croc"]="🐊 croc (Securely send things between computers)"
  ["csvlens"]="📊 csvlens (Visualizador de CSV TUI)"
  ["ctop"]="🐳 ctop (Monitor de métricas para contêineres)"
  ["curlie"]="🦱 curlie (Alternativa moderna para o curl)"
  ["cursor"]="🤖 Cursor AI Code Editor (Futuro do código)"
  ["czg"]="📝 czg (Commitizen CLI)"
  ["d2"]="📊 d2 (Criação declarativa de diagramas)"
  ["dagger"]="🗡️ Dagger (Motor CI/CD programável)"
  ["dapr"]="📦 Dapr CLI (CLI para construção de aplicações distribuídas)"
  ["dasel"]="🔍 dasel (Consulta e atualização de formatos de dados)"
  ["daytona"]="🌅 Daytona (Self-hosted development environment manager)"
  ["dbeaver"]="🐘 DBeaver (Cliente universal para bancos de dados)"
  ["dbmate"]="🗃️ dbmate (Utilitário de migração de banco de dados)"
  ["delta"]="🔀 delta (Formatador de diff com syntax highlighting)"
  ["deno"]="🦕 Deno (Modern JS TS runtime)"
  ["devbox"]="📦 Devbox (Ambientes de desenvolvimento portáteis)"
  ["devenv"]="⚙️ Devenv (Ambientes de desenvolvimento declarativos)"
  ["devpod"]="🚀 DevPod (Codespaces open-source)"
  ["devspace"]="🚀 devspace (Cloud Native Dev Environment)"
  ["devtoy"]="🧰 devtoy (Canivete suíço para desenvolvedores)"
  ["difftastic"]="🧬 difftastic (Ferramenta de diff estrutural)"
  ["direnv"]="🔧 direnv (Gerenciador de variáveis de ambiente por diretório)"
  ["discord"]="🎮 Discord (Comunicação de voz e texto)"
  ["diskonaut"]="💾 diskonaut (Terminal disk space navigator)"
  ["distrobox"]="📦 Distrobox (Run any linux distro in terminal)"
  ["dive"]="🐳 dive (Docker image explorer)"
  ["dnote"]="📓 dnote (A simple command line notebook)"
  ["docker"]="🐳 Docker Engine (Contêineres)"
  ["doggo"]="🐶 doggo (Cliente DNS moderno)"
  ["dolt"]="🐬 dolt (Git for data)"
  ["doppler"]="🔐 Doppler (SecretOps Platform)"
  ["dotenv-linter"]="✅ dotenv-linter (Linter for .env files)"
  ["dotenvx"]="🔑 dotenvx (Manage .env files)"
  ["dprint"]="🖋️ dprint (Plataforma de formatação plugável)"
  ["dsq"]="🗃️ dsq (SQL for JSON CSV etc.)"
  ["dua"]="💽 dua (Analisador de uso de disco)"
  ["dua-cli"]="📊 dua-cli (Analisador de disco)"
  ["duckdb"]="🦆 DuckDB (In-process SQL OLAP DBMS)"
  ["duf"]="🖥️ duf (Utilitário de espaço livre em disco)"
  ["dufs"]="📁 dufs (Servidor de arquivos)"
  ["dura"]="💾 dura (Backup em background para Git)"
  ["dust"]="🌪️ dust (Analisador de uso de disco moderno)"
  ["dysk"]="💽 dysk (Informações sobre discos do Linux)"
  ["earthly"]="🌍 earthly (Build automation)"
  ["eget"]="📥 eget (Download pre-built binaries)"
  ["elixir"]="💧 Elixir (Linguagem funcional dinâmica)"
  ["erdtree"]="🌳 erdtree (File-tree Visualizer)"
  ["evans"]="📡 evans (gRPC client)"
  ["eza"]="🌟 Eza (A modern maintained replacement for ls)"
  ["fabric"]="🤖 fabric (AI CLI framework)"
  ["fastfetch"]="⚡ fastfetch (Modern System Info)"
  ["fd-find"]="📂 fd-find (Alternativa moderna para find)"
  ["fend"]="🧮 fend (Calculadora CLI com suporte a unidades)"
  ["ffuf"]="🔍 ffuf (Fast web fuzzer written in Go)"
  ["firefox"]="🦊 Navegador Firefox (Otimizado)"
  ["flox"]="❄️ Flox (Ambientes de desenvolvedor para todos)"
  ["flyctl"]="✈️ flyctl (Fly.io CLI)"
  ["fnm"]="🐢 fnm (Fast Node Manager)"
  ["fq"]="🔍 fq (jq for binary formats)"
  ["freeze"]="📸 freeze (Code screenshots)"
  ["fx"]="👾 JSON fx (Terminal JSON viewer)"
  ["fzf"]="🔍 Fzf (A command-line fuzzy finder)"
  ["gaze"]="👀 gaze (Execute commands on file changes)"
  ["gcloud"]="☁️ gcloud (Google Cloud CLI)"
  ["gdu"]="📊 gdu (Disk usage analyzer)"
  ["genact"]="🎭 genact (Gerador de atividades falsas)"
  ["gh"]="🐙 gh (GitHub CLI)"
  ["gh-dash"]="🐙 gh-dash (Dashboard do GitHub CLI)"
  ["ghostty"]="👻 Ghostty (Emulador de Terminal Ultrarrápido)"
  ["ghq"]="📂 ghq (Gerenciador de clones de repositórios remotos)"
  ["git-absorb"]="🧽 git-absorb (Utilitário automático para fixups em commits git)"
  ["git-cliff"]="⛰️ git-cliff (Gerador de Changelog)"
  ["git-filter-repo"]="🧹 git-filter-repo (Utilitário para reescrever o histórico do Git)"
  ["git-next"]="🐙 git-next (Trunk-based development manager)"
  ["git-sim"]="🔮 git-sim (Utilitário para simular operações git)"
  ["git-town"]="🏙️ git-town (Suporte a workflow Git de alto nível)"
  ["gitingest"]="🧠 Gitingest (Git to AI prompt)"
  ["gitleaks"]="🔐 gitleaks (Scanner de credenciais vazadas em repositórios)"
  ["gitui"]="🐙 GitUI (Blazing Fast Git TUI)"
  ["glab"]="🦊 glab (GitLab CLI)"
  ["glances"]="👀 glances (Monitor de sistema cross-platform)"
  ["gleam"]="✨ Gleam (Type safe programming language)"
  ["glow"]="🌟 glow (Renderizador de Markdown CLI TUI)"
  ["gobang"]="🗃️ gobang (Cliente de banco de dados TUI)"
  ["gojq"]="🔍 gojq (Processador JSON tipo jq)"
  ["gorilla-cli"]="🦍 gorilla-cli (LLMs for CLI)"
  ["gping"]="🏓 gping (Ping com gráficos)"
  ["gptme"]="🤖 gptme (CLI AI agent)"
  ["grex"]="🧠 grex (Gerador de expressões regulares)"
  ["gron"]="🔧 gron (Utilitário para tornar JSON pesquisável via grep)"
  ["grpcurl"]="📡 grpcurl (curl for gRPC servers)"
  ["grype"]="🔒 grype (Vulnerability scanner for images)"
  ["gtt"]="🌐 gtt (Google Translate TUI)"
  ["gum"]="🍬 gum (Glamorous shell scripts)"
  ["hadolint"]="🐳 hadolint (Linter para Dockerfile)"
  ["harlequin"]="🎩 Harlequin (SQL IDE for terminal)"
  ["hck"]="📦 hck (A sharp cut(1) clone)"
  ["helix"]="🧬 Helix (Post-modern text editor)"
  ["helm"]="⎈ helm (Gerenciador de pacotes para Kubernetes)"
  ["heroku"]="☁️ Heroku CLI (Gerenciar plataformas Heroku)"
  ["hexyl"]="🔢 hexyl (Visualizador Hexagonal TUI)"
  ["howdoi"]="❓ howdoi (Utilitário para buscar respostas de código na linha de comando)"
  ["htmlq"]="📄 htmlq (Manipulador HTML semelhante ao jq)"
  ["htop"]="📊 htop (Monitor de processos TUI)"
  ["httpie"]="🌐 httpie (Cliente HTTP amigável para humanos)"
  ["httpstat"]="📊 httpstat (Estatísticas HTTP visuais)"
  ["httpx"]="⚡ httpx (Utilitário HTTP multiuso)"
  ["hurl"]="🎯 hurl (Testador de requisições HTTP definidas em texto simples)"
  ["hwatch"]="👀 hwatch (Alternativa moderna para o watch)"
  ["hyperfine"]="⏱️ Hyperfine (Utilitário de benchmarking em terminal)"
  ["igrep"]="🔎 igrep (Grep interativo TUI)"
  ["infisical"]="🔐 Infisical (Open Source Secret Management)"
  ["infracost"]="💰 infracost (Cloud cost estimates for Terraform)"
  ["inlyne"]="🖥️ inlyne (Visualizador Markdown)"
  ["inshellisense"]="💡 Inshellisense (IDE style autocomplete for shells)"
  ["jan"]="🤖 Jan (Local AI alternative to ChatGPT)"
  ["jaq"]="🔍 jaq (Clone do jq focado em velocidade)"
  ["jc"]="🔧 jc (Conversor de saída CLI para JSON)"
  ["jira-cli"]="🎫 jira-cli (CLI interativa para o Jira)"
  ["jj"]="🐙 jj (VCS compatível com Git TUI)"
  ["jless"]="🔍 jless (Visualizador de JSON TUI)"
  ["jnv"]="🔍 jnv (Filtro JSON interativo TUI)"
  ["jo"]="🔧 jo (Utilitário de geração de saídas JSON)"
  ["joshuto"]="📁 joshuto (Gerenciador de arquivos no terminal)"
  ["jq"]="🔍 jq (Processador CLI para linguagem de consulta JSON)"
  ["jql"]="🔍 jql (Processador JSON estilo jq TUI)"
  ["jqp"]="🔍 jqp (Playground interativo para jq TUI)"
  ["jujutsu"]="🥋 jujutsu (Um sistema de controle de versão VCS)"
  ["just"]="🤖 just (Substituto moderno para make)"
  ["k3d"]="🐳 k3d (Lightweight Kubernetes in Docker)"
  ["k3s"]="☸️ k3s (Lightweight Kubernetes)"
  ["k6"]="🚀 k6 (Utilitário moderno de testes de carga)"
  ["k8sgpt"]="☸️ k8sgpt (IA diagnosticando problemas no Kubernetes)"
  ["k9s-cli"]="🐶 k9s-cli (Kubernetes CLI TUI)"
  ["kakoune"]="🚀 kakoune (Better Vim)"
  ["kalker"]="🧮 kalker (Calculadora de matemática TUI)"
  ["kaskade"]="🌊 kaskade (Kafka TUI)"
  ["kcl"]="📝 kcl (KCL Configuration Language)"
  ["kdash"]="☸️ kdash (Kubernetes Dashboard)"
  ["kew"]="🎵 kew (CLI music player)"
  ["kind"]="🐳 kind (Kubernetes in Docker)"
  ["klog"]="⏱️ klog (Utilitário para rastreamento de tempo)"
  ["kmon"]="🐧 kmon (Gerenciador de Kernel Linux)"
  ["ko"]="📦 ko (Build e deploy de aplicações Go no Kubernetes)"
  ["kondo"]="🧹 kondo (Limpeza de dependências e arquivos inúteis TUI)"
  ["krew"]="🔌 krew (Gerenciador de plugins para kubectl)"
  ["kubecolor"]="🎨 kubecolor (Utilitário para colorir saídas do kubectl)"
  ["kubectl"]="⎈ kubectl (Cliente de linha de comando para Kubernetes)"
  ["kubectx"]="⎈ kubectx (Troca de contextos do Kubernetes)"
  ["kubens"]="📦 kubens (Utilitário rápido para trocar namespaces do Kubernetes)"
  ["kubent"]="☸️ kubent (Verificador de APIs deprecadas no Kubernetes)"
  ["kustomize"]="🛠️ kustomize (Gerenciamento nativo de configuração do Kubernetes)"
  ["lapce"]="⚡ Lapce (Lightning-fast Code Editor in Rust)"
  ["kew"]="🎵 kew (Command-line music player)"
  ["gaze"]="👀 gaze (Run commands based on file changes)"
  ["dnote"]="📓 dnote (Command line notebook)"
  ["lazydocker"]="🐳 LazyDocker TUI (Contêineres com Estilo)"
  ["lazygit"]="🐙 lazygit (Simple terminal UI for git commands)"
  ["lazygit-tui"]="🐙 lazygit-tui TUI (Git feito certo)"
  ["lazynpm"]="📦 Lazynpm (NPM TUI)"
  ["lazysql"]="🦥 Lazysql (SQL Client TUI)"
  ["lazyvim"]="💤 lazyvim (Neovim starter)"
  ["lefthook"]="🪝 lefthook (Gerenciador rápido de hooks git)"
  ["lens"]="👁️ lens (Kubernetes IDE)"
  ["lf"]="📁 lf (Gerenciador de arquivos inspirado no ranger)"
  ["litecli"]="🗃️ litecli (Cliente de linha de comando para SQLite)"
  ["llm"]="🧠 LLM (Access Large Language Models)"
  ["lmstudio"]="🤖 LM Studio (Rode LLMs locais com interface gráfica)"
  ["lnav"]="📋 lnav (Navegador e analisador de logs TUI)"
  ["lsd"]="🌟 lsd (LSDeluxe ls moderno)"
  ["lychee"]="🔗 lychee (Checador de links rápido)"
  ["macchina"]="💻 macchina (Fetch de informações do sistema rápido)"
  ["mani"]="📂 mani (Utilitário CLI para gerenciar múltiplos repositórios)"
  ["marimo"]="📓 marimo (Reactive Python Notebooks)"
  ["mcfly"]="🧠 mcfly (Buscador inteligente de histórico de shell)"
  ["mdcat"]="🐈 mdcat (Visualizador Markdown)"
  ["melt"]="🔑 melt (Gerenciador seguro para chaves Ed25519)"
  ["micro"]="🚀 micro (Editor de texto de terminal moderno TUI)"
  ["miller"]="📊 miller (Manipulador canivete-suíço para CSV TSV e JSON)"
  ["miniserve"]="🗄️ miniserve (Servidor web leve e rápido)"
  ["mise"]="🛠️ mise (Gerenciador de versões poliglota)"
  ["mkcert"]="🔐 mkcert (Gerador de certificados locais confiáveis)"
  ["mlr"]="📊 mlr (Manipulador canivete-suíço para CSV TSV e JSON)"
  ["moar"]="📄 moar (Pager terminal moderno TUI)"
  ["mods"]="🤖 Mods (AI on the command line)"
  ["monolith"]="📦 monolith (Salva páginas da web como um arquivo HTML único)"
  ["moon"]="🌙 Moon (Build system for JS TS)"
  ["mprocs"]="🔄 mprocs (Gerenciador de processos paralelos TUI)"
  ["mycli"]="🐬 mycli (Cliente de linha de comando para MySQL)"
  ["mysql"]="🐬 MySQL Server & Client (Bancos de Dados)"
  ["nap"]="😴 nap (Gerenciador de snippets no terminal)"
  ["navi"]="🧭 navi (Cheatsheet de comandos TUI)"
  ["ncdu"]="🚀 ncdu (Analisador de uso de disco baseado no terminal TUI)"
  ["ncspot"]="🎵 ncspot (Cliente cross-platform para o Spotify TUI)"
  ["neofetch-alt"]="⚡ neofetch-alt (Modern System Info)"
  ["neovim"]="📝 Neovim (Editor de texto avançado)"
  ["netlify"]="▲ Netlify CLI (Deploy and manage sites)"
  ["newsboat"]="📰 newsboat (RSS Atom feed reader)"
  ["ngrok"]="🚇 ngrok (Secure introspectable tunnels to localhost)"
  ["nix"]="❄️ Nix (Modern package manager)"
  ["nnn"]="🚀 nnn (Gerenciador de arquivos super-rápido TUI)"
  ["nomad"]="🚀 Nomad (Workload Orchestrator)"
  ["nuclei"]="⚡ nuclei (Targeted vulnerability scanner)"
  ["numbat"]="🧮 numbat (Calculadora com avaliação TUI)"
  ["nushell"]="🐚 Nushell (A new type of shell)"
  ["obsidian"]="📓 Obsidian (Second Brain & Notas)"
  ["oh-my-posh"]="🎨 oh-my-posh (Prompt theme engine)"
  ["oha"]="📈 oha (Gerador de carga HTTP TUI)"
  ["ollama"]="🦙 Ollama (Rode LLMs localmente)"
  ["onefetch"]="📊 onefetch (Informações de projetos Git TUI)"
  ["open-interpreter"]="🤖 Open-Interpreter (LLMs executando código)"
  ["opentofu"]="🏗️ OpenTofu (Infrastructure as Code)"
  ["ouch"]="🗜️ ouch (Compressor e descompressor TUI)"
  ["oxker"]="🐳 oxker (Visualizador e controlador de contêineres Docker TUI)"
  ["oxlint"]="🐂 oxlint (Linter ultrarrápido para JS TS)"
  ["packer"]="📦 Packer (Build Automated Machine Images)"
  ["pastel"]="🎨 pastel (Utilitário manipulador de cores CLI)"
  ["peco"]="🔍 peco (Filtrador interativo no terminal TUI)"
  ["pgcli"]="🐘 pgcli (Cliente de linha de comando para PostgreSQL)"
  ["pipes-rs"]="🚰 pipes-rs (Screensaver animado TUI)"
  ["pipes-sh"]="🚰 pipes-sh (Screensaver TUI em Bash)"
  ["pixi"]="📦 pixi (Fast package manager for Python and C++)"
  ["pkgx"]="📦 pkgx (Blazing fast package manager)"
  ["plandex"]="🤖 Plandex (AI coding engine)"
  ["pls"]="🤖 pls (AI-powered CLI assistant)"
  ["pnpm"]="📦 pnpm (Fast package manager)"
  ["podman"]="🦭 Podman (Daemonless container engine)"
  ["poetry"]="📦 poetry (Python packaging and dependency management made easy)"
  ["pokeget"]="👾 pokeget (Sprites de pokémons no terminal TUI)"
  ["pomsky"]="🐾 pomsky (Linguagem elegante para geração de regex TUI)"
  ["popeye"]="👀 popeye (Verificador de recursos do cluster Kubernetes)"
  ["porsmo"]="🍅 porsmo (Temporizador pomodoro e descanso)"
  ["posting"]="📮 posting (Cliente HTTP TUI)"
  ["presenterm"]="📽️ presenterm (Apresentador de slides markdown TUI)"
  ["procs"]="🔍 procs (Substituto moderno para ps)"
  ["proto"]="🔧 proto (Pluggable next-generation version manager by moonrepo)"
  ["pueue"]="🗃️ pueue (Gerenciador de tarefas TUI de background)"
  ["pulumi"]="🏗️ Pulumi (Infrastructure as Code)"
  ["px"]="📊 px (Monitor de processos alternativo ao ps e top)"
  ["qsv"]="📊 qsv (Ferramentas de análise de dados CSV)"
  ["repomix"]="📦 Repomix (Pack repo for AI)"
  ["rio"]="🎨 Rio (Hardware-accelerated GPU terminal emulator)"
  ["rip"]="🗑️ rip (Alternativa segura e intuitiva ao rm)"
  ["ripgrep"]="⚡ ripgrep (Buscador orientado a linha ultra rápido)"
  ["ripgrep_all"]="📦 ripgrep_all (ripgrep aprimorado para busca em diversos formatos)"
  ["rnr"]="🔄 rnr (Utilitário rápido para renomear arquivos)"
  ["rs-cmatrix"]="💻 rs-cmatrix (Efeito cmatrix escrito em Rust)"
  ["ruff"]="⚡ Ruff (Extremely fast Python linter)"
  ["ruplacer"]="🔄 ruplacer (Substituidor de strings interativo TUI)"
  ["rustscan"]="🔍 rustscan (Port scanner rápido)"
  ["rye"]="🌾 Rye (Hassle-free Python experience)"
  ["sad"]="😢 sad (Busca e substituição no terminal TUI)"
  ["scc"]="📊 scc (Contador rápido de estatísticas de código)"
  ["sd"]="🔍 sd (Busca e substituição TUI)"
  ["serie"]="📈 serie (Gráfico TUI interativo para commits)"
  ["serpl"]="🔍 serpl (Interface de busca e substituição TUI)"
  ["sesh"]="🖥️ sesh (Gerenciador de sessões TUI inteligente)"
  ["shell-gpt"]="💬 Shell-GPT (ChatGPT from terminal)"
  ["shellcheck"]="🐚 shellcheck (Analisador e linter estático para scripts de shell)"
  ["shfmt"]="✨ shfmt (Formatador para arquivos shell script)"
  ["silicon"]="📸 silicon (Criador de screenshots sintáticas bonitas TUI)"
  ["skate"]="🔑 skate (Banco local chave-valor TUI criptografado)"
  ["skim"]="🔍 skim (Fuzzy Finder escrito em Rust TUI)"
  ["slack"]="💬 Slack Desktop (Comunicação)"
  ["slides"]="📊 slides (Apresentações baseadas em terminal TUI)"
  ["slumber"]="😴 slumber (Cliente HTTP TUI)"
  ["sniffnet"]="🕸️ sniffnet (Analisador visual de tráfego de rede TUI)"
  ["so"]="🔍 so (Interface de terminal para o StackOverflow)"
  ["sops"]="🔐 sops (Utilitário flexível de edição de arquivos secretos)"
  ["spacer"]="📏 spacer (Insere espaços em branco para organização TUI)"
  ["spt"]="🎵 spt (Cliente TUI para Spotify Premium)"
  ["sqlc"]="🗄️ sqlc (Gerador de código seguro por tipos a partir de SQL)"
  ["starship"]="🚀 Starship Prompt (Synthwave '84 ativado)"
  ["steampipe"]="☁️ steampipe (Interface SQL flexível para infraestrutura na nuvem)"
  ["stern"]="📋 stern (Visualizador consolidado de logs de múltiplos pods e contêineres)"
  ["stripe"]="💳 Stripe CLI (Interact with Stripe API)"
  ["supabase"]="⚡ supabase (Integração CLI com os serviços do Supabase)"
  ["superfile"]="📁 Superfile (Terminal File Manager)"
  ["syft"]="📦 syft (Analista de arquivos gerando um SBOM transparente)"
  ["systemctl-tui"]="⚙️ systemctl-tui (Interface TUI rápida para serviços do systemd)"
  ["systeroid"]="🧠 systeroid (Visão avançada dos parâmetros sysctl com TUI)"
  ["sysz"]="⚙️ sysz (Menu de interação wrapper sobre o systemctl interativo)"
  ["t-rec"]="📼 t-rec (Gravador ultrarrápido de ações no terminal em formato GIF TUI)"
  ["tailspin"]="🪵 tailspin (Log Highlighter inteligente)"
  ["taplo"]="⚙️ taplo (Validador e linter extensível focado em TOML)"
  ["task"]="✅ task (Runners intuitivos emulando uma versão amigável do make)"
  ["taskwarrior-tui"]="✅ taskwarrior-tui (Interface gráfica flexível baseada em TUI ao taskwarrior)"
  ["tealdeer"]="🦌 tealdeer (Implementação ultraveloz Rust para busca no tldr)"
  ["television"]="📺 television (Visualizador fuzzy ultrarrápido e modular)"
  ["tenki"]="⛅ tenki (Informações minimalistas de clima renderizadas via TUI)"
  ["tenv"]="🌍 tenv (Utilitário gerenciador agnóstico de múltiplas versões IaC)"
  ["tere"]="🚀 tere (Ferramenta TUI veloz integrando atalhos e atalhos na árvore de navegação)"
  ["termdbms"]="🗄️ termdbms (Visor TUI de arquivos de banco de dados)"
  ["termscp"]="📁 termscp (Explorador rápido focado em transferências de arquivos e comunicação SSH FTP TUI)"
  ["termshark"]="🦈 termshark (Inspeção visual emulando o Wireshark encapsulada como CLI)"
  ["termtyper"]="⌨️ termtyper (Aplicativo modular em TUI estimulando treinos práticos e velozes de digitação)"
  ["terragrunt"]="🏗️ terragrunt (Utilitário flexível para orquestração modular otimizando fluxos complexos em Terraform)"
  ["tflint"]="🔍 tflint (Plataforma extensível com análise estática de módulos orientados a Terraform)"
  ["tfsec"]="🛡️ tfsec (Testador abrangente orientado ao Terraform analisando falhas persistentes de infra)"
  ["tgpt"]="🤖 tgpt (Terminal ChatGPT)"
  ["thefuck"]="🤬 thefuck (Módulo corretor em tempo real reavaliando comandos mal formados no histórico CLI)"
  ["tickrs"]="📈 tickrs (Monitor estático agregando dados atualizados baseados nos indicadores da bolsa via TUI)"
  ["tig"]="🚀 tig (Ambiente consolidado iterando sobre os fluxos complexos baseados no formato ncurses TUI)"
  ["tilt"]="🛠️ tilt (Framework inteligente facilitando reloads flexíveis no Kubernetes durante desenvolvimento local)"
  ["tin-summer"]="☀️ tin-summer (Rastreador inteligente TUI para purga progressiva de artefatos de compilação)"
  ["tldr"]="📚 tldr (Coleção compacta substituindo manpages visuais fornecendo atalhos consolidados por comandos TUI)"
  ["tlrc"]="📚 tlrc (Frontend oficial conectando repositórios robustos do TLDR de forma interativa e visual TUI)"
  ["tmate"]="🤝 tmate (Sistema rápido estabelecendo proxy local para compartilhamento instantâneo via sessões conectadas TUI)"
  ["tmux"]="🪟 tmux (Gerenciador multijanelas focado em estabilidade distribuindo sessões integradas nativamente TUI)"
  ["tokei"]="⏰ tokei (Analista super rápido retornando métricas precisas rastreando sintaxe estruturada nas bases)"
  ["topgrade"]="🚀 topgrade (Interface conectora garantindo atualização abrangente disparando módulos por ambiente de gerenciadores diversos)"
  ["trash-cli"]="🗑️ trash-cli (Proteção ativa sobre lixeira segura embutindo lixeira persistente predefinindo restauros)"
  ["tre"]="🌲 tre (Visor modular modernizando saída mapeada na árvore substituindo interfaces originais lentas do comando clássico)"
  ["trippy"]="🗺️ trippy (Diagnóstico TUI visualizando rotas e pings com painéis gráficos)"
  ["trivy"]="🛡️ trivy (Varredura inteligente alertando exposições de segredos em tempo interativo nas imagens e pacotes gerados)"
  ["trufflehog"]="🐷 trufflehog (Auditoria rigorosa TUI procurando segredos vazados abrangendo bases inteiras reescrevendo histórico remoto)"
  ["trzsz"]="📤 trzsz (Transferência inteligente implementada com transparência interagindo TUI de maneira assíncrona ao tmux)"
  ["tt"]="⌨️ tt (Modulo visual aferindo teste rápido rastreando taxas digitadas iterando sobre histórico progressivo TUI)"
  ["ttyd"]="🌐 ttyd (Hospedeiro CLI modular exibindo proxy persistente transladando comandos a visualizadores acessíveis na web remotamente)"
  ["ttyper"]="⌨️ ttyper (Interação gráfica aferindo habilidade digitadora iterando progressivamente aos modos diversos nativos TUI)"
  ["turso"]="🗄️ turso (CLI moderna interagindo com ecossistema orientado a dados remotos otimizando chamadas de serviços)"
  ["typos"]="📝 typos (Analista assíncrono corrigindo ortografia varrendo bases inteiras sem dependências lentas externas TUI)"
  ["typos-cli"]="📝 typos-cli (Variante distribuída corrigindo digitação falha TUI acionando integrações automáticas globais de CI)"
  ["typst"]="📝 typst (Linguagem minimalista fornecendo compilador interativo focado em elaboração nativa renderizando PDFs via CLI)"
  ["ugit"]="⏪ ugit (Rastreador inteligente refazendo históricos perdidos otimizando refatoração baseada nos logs iterativos do git TUI)"
  ["ugrep"]="🔍 ugrep (Sistema interativo expandindo compatibilidade do grep com buscas complexas formatando saída persistente via TUI)"
  ["usql"]="🗄️ usql (Integração universal conectora iterando nativamente conexões abrangendo ecossistema múltiplo de bancos TUI)"
  ["uv"]="🐍 uv (Gerenciador de bibliotecas e pacotes substituindo PIP)"
  ["vault"]="🔐 vault (Gerenciador robusto centralizado para segurança unificada provendo segredos criptografados)"
  ["vcluster"]="⎈ vcluster (Configurador modular emulando partições de hardware escalando instâncias virtualizadas gerenciando espaços em K8s TUI)"
  ["vegeta"]="🔫 vegeta (Motor assíncrono de testes aferindo requisições HTTP simulando latências em stress remoto via CLI)"
  ["vercel"]="▲ vercel (Controle extensível interagindo via TUI unificando deploys severless nativamente iterados aos servidores remotos em produção)"
  ["vhs"]="📼 vhs (Acessório nativo gravando sessões visuais programáticas exportadas modularmente convertendo formatos assíncronos integrados de GIFs interativos)"
  ["viddy"]="⌚ viddy (Emulador persistente customizado visualizando comandos progressivos renderizados temporalmente ao invés de abordagens clássicas e lentas)"
  ["visidata"]="📊 visidata (Engenharia visual canivete-suíço processando dados iterativos via planilhas nativas complexas e minimalistas TUI)"
  ["viu"]="🖼️ viu (Modulo interativo transladando mídias convertidas estáticas adaptando protocolos de rendering compatíveis visuais CLI)"
  ["vivid"]="🌈 vivid (Utilitário renderizador de metadados visuais reavaliando perfis compatíveis associando estilos padronizados CLI)"
  ["vscode"]="💻 Visual Studio Code (Setup Moderno)"
  ["walk"]="🚶 walk (Caminhador visual iterativo integrando busca emulando gerência exploradora persistindo em instâncias leves adaptáveis na navegação TUI)"
  ["warp"]="⚡ Warp Terminal (AI & GPU Acelerado)"
  ["watchexec"]="👀 watchexec (Orquestrador vigilante ativando tarefas emuladas responsivamente engatilhadas por modulações interativas nos diretórios complexos monitorados CLI)"
  ["waypoint"]="🎯 waypoint (Agregador CLI distribuído interagindo deploys progressivos orientados automatizando ciclos integrados remotamente aos repositórios)"
  ["websocat"]="🌐 websocat (Terminal cliente integrado iterando conexões flexíveis rastreando transmissões reativas emuladas interativamente por websockets TUI)"
  ["wezterm"]="💻 WezTerm (Emulador de terminal acelerado por GPU)"
  ["wiki-tui"]="📖 wiki-tui (Visualizador de artigos do Wikipedia através de uma TUI rápida escrita em Rust)"
  ["windsurf"]="🏄 Windsurf (AI IDE da Codeium)"
  ["wtf"]="🖥️ wtf (Console nativo orquestrando widgets customizados centralizando informativos progressivos TUI)"
  ["wtfutil"]="🖥️ wtfutil (Adaptador de integração painel unificando dados remotos via serviços visuais TUI organizados centralizadamente)"
  ["wthrr"]="🌦️ wthrr (Visualizador renderizando clima remoto associando gráficos modulares iterativos baseados localmente na rede via CLI)"
  ["wthrr-the-weathercrab"]="🌦️ wthrr-the-weathercrab (Extensão metereológica CLI renderizando painéis amigáveis iterativos localmente orientados aos acessos temporais e climáticos visuais TUI)"
  ["wuzz"]="🌐 wuzz (Visor TUI flexível orquestrando inspeções interativas detalhando métricas isoladas rastreando logs gerados em requisições assíncronas aos servidores externos CLI)"
  ["xc"]="📝 xc (Formatador executável iterando runners simplificados embutidos mapeando tags em markdowns formatados executando CLI)"
  ["xcp"]="🚀 xcp (Ferramenta TUI transferidora otimizada iterando cópias seguras agregadas por indicadores gráficos visuais substituindo abordagens lentas emuladas estaticamente nativas CLI)"
  ["xh"]="🌐 xh (Interface CLI canivete-suíço interagindo progressivamente integrando conexões simplificadas requisições HTTP seguras assíncronas convertidas otimizadamente via terminal TUI)"
  ["xplr"]="📁 xplr (TUI file explorer)"
  ["xsv"]="📊 xsv (Extensor modular canivete-suíço otimizando leitura estática agregando modificações complexas orientadas em arquivos CSV CLI unificados remotamente interativos TUI)"
  ["yamlfmt"]="✨ yamlfmt (Agregador nativo de parsing orientando sintaxe estática embutindo conversões unificadas adaptáveis modulares a arquivos yaml progressivamente validados CLI e editados TUI interativamente e localmente)"
  ["yazi"]="🦆 Yazi File Manager (Arquivos na velocidade da luz)"
  ["yq"]="🔍 yq (Transpilador JSON integrando fluxos jq adaptados estruturando formatações persistentes iterativas orientando parsers visuais CLI a arquivos modulares de configuração YAML)"
  ["yt-dlp"]="🎥 yt-dlp (Video downloader)"
  ["zed"]="💻 Zed Editor (Escrito em Rust)"
  ["zellij"]="🪟 Zellij Terminal Multiplexer (Workspace Moderno)"
  ["zen-browser"]="🌐 Zen Browser (Navegador ultrarrápido focado em privacidade)"
  ["zenith"]="📈 zenith (Monitor detalhado do uso de hardware no terminal usando gráficos em tempo real)"
  ["zig"]="⚡ Zig (Modern programming language)"
  ["zizmor"]="🛡️ zizmor (Auditoria nativa TUI orquestrando vulnerabilidades estáticas de segurança nas actions geradas de repositórios iterados de integração assíncrona ao GitHub flexível adaptando CLI para verificação TUI)"
  ["zoxide"]="🚀 Zoxide (A smarter cd command)"
  ["zrok"]="🔗 zrok (Open source ngrok alternative)"
  ["kew"]="🎵 kew (Terminal music player)"
  ["gaze"]="👀 gaze (Run commands when files change)"
  ["dnote"]="📓 dnote (A simple command line notebook)"
  ["zsh"]="🐚 Zsh shell e plugins (Hiper-produtividade)"

  ["kew"]="🎵 kew (Command-line music player)"
  ["gaze"]="👀 gaze (Execute commands when files change)"
  ["dnote"]="📝 dnote (A simple command line notebook for programmers)"
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
    --cursor.foreground="#36f9f6" \
    --item.foreground="#f8f8f2" \
    --header="🌟 $($GUM style --foreground "#36f9f6" --bold "CATÁLOGO NEXUS DE MÓDULOS 2026") (pressione '/' para buscar):" \
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
      join_args+=("$(printf "%b\n" "$MOD_LIST" | tail -n +$((i * rows + 1)) | head -n $rows)")
      if [ $i -lt $((cols - 1)) ]; then
        join_args+=("  ")
      fi
    done
    echo "$("$GUM" join --horizontal "${join_args[@]}")" | "$GUM" style --border double --margin "1 2" --padding "2 4" --border-foreground "#36f9f6"
  else
    printf "%b\n" "$MOD_LIST" | "$GUM" style --border double --margin "1 2" --padding "2 4" --border-foreground "#36f9f6"
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
    --foreground "#f8f8f2" --border-foreground "#36f9f6" --border double \
    --align center --width 70 --margin "3 2" --padding "4 6" \
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
      --affirmative "⚡ Iniciar Conexão!" \
      --negative "🛑 Abortar Missão" \
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
