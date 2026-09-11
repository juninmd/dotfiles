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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship vscode sd choose gobang bottom macchina xplr circumflex lsd lazydocker lazygit-tui k9s-cli posting aider)
    ;;
  dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit-tui lazydocker vscode ghostty zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aichat duckdb lazysql harlequin)
    ;;
  full)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce fastfetch)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp ghostty lazygit-tui lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s-cli posting superfile aider plandex open-interpreter duckdb harlequin neofetch-alt lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aider-chat trippy onefetch grex bandwhich amber tailspin erdtree dua oxlint difftastic topgrade pastel numbat dufs jj sesh carapace moar vhs gitleaks xc gdu trash-cli yt-dlp glances d2 poetry pnpm fnm gping kondo presenterm hexyl csvlens pomsky bacon wiki-tui ast-grep dive gron viddy wtfutil cointop dasel dust navi delta websocat ouch zenith git-cliff typos fend joshuto sniffnet termscp wthrr miniserve zizmor inlyne so xcp taplo tlrc typst xsv gh act task croc dbmate ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next gptme ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce tmux htop cmatrix vivid hadolint ugit pgcli mycli litecli tere kubent lazyvim oh-my-posh micro nnn tig ncdu kakoune fastfetch hck termshark kmon)
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
  ["act"]="🎭 act (Executa GitHub Actions localmente)"
  ["actionlint"]="📦 actionlint (Verificador estático para workflows do GitHub Actions)"
  ["age"]="📦 age (Criptografia moderna de arquivos)"
  ["aichat"]="💬 aichat (AI Chat)"
  ["aider"]="🤖 Aider-chat (AI pair programming)"
  ["aider-chat"]="🤖 Aider-chat (AI pair programming)"
  ["amber"]="🔍 amber (Search & Replace)"
  ["android"]="📱 Android Studio & SDK (Plataforma Mobile)"
  ["aqua"]="💧 aqua (Declarative CLI Version Manager)"
  ["argc"]="🐚 argc (A bash CLI framework)"
  ["argocd"]="🐙 ArgoCD (Declarative GitOps for K8s)"
  ["ast-grep"]="🌳 ast-grep (Busca e substituição baseada em AST)"
  ["atac"]="🚀 Atac (Cliente de API Moderno TUI)"
  ["atlas"]="📦 atlas (Gerenciador moderno de esquemas de banco de dados)"
  ["atuin"]="🐢 Atuin (Histórico de shell mágico)"
  ["awscli"]="☁️ AWS CLI (Interface de linha de comando AWS)"
  ["bacon"]="🥓 bacon (Verificador de código Rust em segundo plano)"
  ["bandwhich"]="📈 bandwhich (Monitor de largura de banda)"
  ["bat"]="🦇 Bat (Um clone do cat com asas)"
  ["bat-extras"]="🦇 bat-extras (Scripts bash que integram bat com utilitários cli)"
  ["binsider"]="🔍 binsider (Analisador de binários ELF)"
  ["biome"]="🚀 Biome (Conjunto de utilitários rápidos JS/TS)"
  ["bito"]="🤖 bito (CLI assistente de IA)"
  ["bluetuith"]="🦷 bluetuith (Bluetooth manager TUI)"
  ["bore-cli"]="🚇 bore-cli (Tunelamento local de portas)"
  ["bottom"]="📈 bottom (Monitor de sistema TUI)"
  ["boundary"]="🛡️ boundary (Gerenciamento de acesso baseado em identidade)"
  ["brave"]="🦁 Brave (Navegador focado em privacidade)"
  ["broot"]="🌲 Broot (Uma nova forma de navegar em árvores de diretórios)"
  ["bruno"]="🐶 Bruno (API Client open-source e leve)"
  ["bruno-cli"]="🐶 bruno-cli (Cliente de API via CLI)"
  ["btop"]="📊 Btop (Monitor de recursos interativo)"
  ["bun"]="🥟 Bun JavaScript runtime (Ultrarrápido)"
  ["bw"]="🔐 Bitwarden CLI (Gerenciador de senhas)"
  ["carapace"]="🐚 carapace (Completador multi-shell)"
  ["cbonsai"]="🌲 cbonsai (Gerador de bonsai no terminal)"
  ["chafa"]="🎨 chafa (Gráficos no terminal)"
  ["charm"]="✨ charm (Utilitário Charmbracelet)"
  ["chatbox"]="💬 Chatbox (Copiloto para o desktop)"
  ["chatgpt-cli"]="🤖 chatgpt-cli (ChatGPT no terminal)"
  ["cheat"]="📄 cheat (Cheatsheets interativas)"
  ["checkov"]="🛡️ checkov (Scanner de segurança para IaC)"
  ["choose"]="✂️ choose (Alternativa amigável ao cut)"
  ["circumflex"]="📰 circumflex (Hacker News no terminal)"
  ["claude-code"]="🤖 Claude Code (AI Assistant CLI da Anthropic)"
  ["cli-tools"]="🧰 Dependências Base 2026 (Rust Go Python build-utils)"
  ["cline"]="🤖 Cline (Autonomous coding agent CLI)"
  ["cloudflared"]="☁️ cloudflared (Cliente Cloudflare Tunnel)"
  ["cmatrix"]="💻 cmatrix (Classic Matrix terminal effect)"
  ["cocogitto"]="⚙️ cocogitto (CLI para conventional commits)"
  ["code2prompt"]="📝 code2prompt (Converte base de código para prompt LLM)"
  ["cointop"]="🪙 cointop (Rastreador de criptomoedas TUI)"
  ["common"]="⚙️ Scripts compartilhados e helpers"
  ["consul"]="🌐 Consul (Networking de serviços)"
  ["cpufetch"]="💻 cpufetch (Busca arquitetura da CPU)"
  ["crane"]="🏗️ crane (Interação com imagens de contêiner)"
  ["croc"]="🐊 croc (Transferência segura de arquivos)"
  ["csvlens"]="📊 csvlens (Visualizador de CSV TUI)"
  ["ctop"]="🐳 ctop (Interface top-like para métricas de contêineres)"
  ["curlie"]="🦱 Curlie (curl + httpie)"
  ["cursor"]="🤖 Cursor AI Code Editor (Futuro do código)"
  ["czg"]="📝 czg (Commitizen CLI)"
  ["d2"]="📊 d2 (Criação declarativa de diagramas)"
  ["dagger"]="🗡️ Dagger (Motor CI/CD programável)"
  ["dapr"]="📦 Dapr CLI (CLI para construção de aplicações distribuídas)"
  ["dasel"]="🔍 dasel (Consulta e atualiza formatos de dados)"
  ["daytona"]="🌅 Daytona (Gerenciador de ambiente de desenvolvimento self-hosted)"
  ["dbeaver"]="🐘 DBeaver (Cliente universal para bancos de dados)"
  ["dbmate"]="🗃️ dbmate (Utilitário de migração de banco de dados)"
  ["delta"]="🔀 delta (Visualizador com syntax-highlighting para git diff)"
  ["deno"]="🦕 Deno (Modern JS TS runtime)"
  ["devbox"]="📦 Devbox (Ambientes de desenvolvimento portáteis)"
  ["devenv"]="⚙️ Devenv (Ambientes de desenvolvimento declarativos)"
  ["devpod"]="🚀 DevPod (Codespaces open-source)"
  ["devspace"]="🚀 devspace (Cloud Native Dev Environment)"
  ["devtoy"]="🧰 devtoy (Canivete suíço para desenvolvedores)"
  ["difftastic"]="🧬 difftastic (Ferramenta de diff estrutural)"
  ["direnv"]="🔧 direnv (Gerenciador de variáveis de ambiente por diretório)"
  ["discord"]="🎮 Discord (Comunicação de voz e texto)"
  ["diskonaut"]="💾 diskonaut (Navegador visual de espaço em disco no terminal)"
  ["distrobox"]="📦 Distrobox (Rode qualquer distro linux no terminal)"
  ["dive"]="🐳 dive (Explorador de imagens Docker)"
  ["docker"]="🐳 Docker Engine (Contêineres)"
  ["doggo"]="🐶 Doggo (Cliente DNS moderno)"
  ["dolt"]="🐬 dolt (Git para dados)"
  ["doppler"]="🔐 Doppler (Plataforma SecretOps)"
  ["dotenv-linter"]="✅ dotenv-linter (Linter para arquivos .env)"
  ["dotenvx"]="🔑 dotenvx (Gerenciador de arquivos .env)"
  ["dprint"]="🖋️ dprint (Plataforma de formatação conectável)"
  ["dsq"]="🗃️ dsq (SQL para JSON/CSV/etc)"
  ["dua"]="💽 dua (Analisador de uso de disco)"
  ["dua-cli"]="📊 dua-cli (Analisador de uso de disco)"
  ["duckdb"]="🦆 DuckDB (In-process SQL OLAP DBMS)"
  ["duf"]="🖥️ duf (Utilitário de uso de disco)"
  ["dufs"]="📁 dufs (Servidor de arquivos utilário)"
  ["dura"]="💾 dura (Backup de git em background)"
  ["dust"]="🌪️ dust (Versão mais intuitiva do du escrita em rust)"
  ["dysk"]="💽 dysk (Informações de disco do Linux)"
  ["earthly"]="🌍 earthly (Automação de build)"
  ["eget"]="📥 eget (Baixa binários pré-compilados)"
  ["elixir"]="💧 Elixir (Linguagem funcional dinâmica)"
  ["erdtree"]="🌳 erdtree (Visualizador de árvore de arquivos em Rust)"
  ["evans"]="grpc evans (gRPC client)"
  ["eza"]="🌟 Eza (Substituto moderno e mantido para o ls)"
  ["fabric"]="🤖 fabric (Framework de IA CLI)"
  ["fastfetch"]="⚡ fastfetch (Modern System Info)"
  ["fd-find"]="📂 fd (Alternativa simples/rápida e amigável ao find)"
  ["fend"]="🧮 fend (Calculadora ciente de unidades e de precisão arbitrária)"
  ["ffuf"]="🔍 ffuf (Fuzzer web rápido escrito em Go)"
  ["firefox"]="🦊 Navegador Firefox (Otimizado)"
  ["flox"]="❄️ Flox (Ambientes de desenvolvedor para todos)"
  ["flyctl"]="✈️ flyctl (Fly.io CLI)"
  ["fnm"]="🐢 fnm (Fast Node Manager)"
  ["fq"]="🔍 fq (jq para formatos binários)"
  ["freeze"]="📸 freeze (Capturas de tela de código)"
  ["fx"]="👾 JSON fx (Terminal JSON viewer)"
  ["fzf"]="🔍 Fzf (Buscador fuzzy de linha de comando)"
  ["gcloud"]="☁️ gcloud (Interface de linha de comando Google Cloud)"
  ["gdu"]="📊 gdu (Analisador de uso de disco com interface TUI)"
  ["genact"]="🎭 genact (Gerador de atividade falsa)"
  ["gh"]="🐙 gh (GitHub CLI)"
  ["gh-dash"]="🐙 gh-dash (Dashboard do GitHub CLI)"
  ["ghostty"]="👻 Ghostty (Emulador de Terminal Ultrarrápido)"
  ["ghq"]="📂 ghq (Gerencia clones de repositórios remotos)"
  ["git-absorb"]="🧽 git-absorb (Correção automática de git commit)"
  ["git-cliff"]="⛰️ git-cliff (Gerador de changelog altamente customizável)"
  ["git-filter-repo"]="🧹 git-filter-repo (Reescreve histórico do git)"
  ["git-next"]="🐙 git-next (Gerenciador de desenvolvimento trunk-based)"
  ["git-sim"]="🔮 git-sim (Simulador visual de operações do Git)"
  ["git-town"]="🏙️ git-town (Suporte para fluxos de trabalho de alto nível no Git)"
  ["gitingest"]="🧠 Gitingest (Git para prompt de IA)"
  ["gitleaks"]="🔐 gitleaks (Scanner de segredos para git)"
  ["gitui"]="🐙 GitUI (TUI de Git incrivelmente rápida)"
  ["glab"]="🦊 glab (GitLab CLI)"
  ["glances"]="👀 glances (Monitor de sistema cross-platform)"
  ["gleam"]="✨ Gleam (Type safe programming language)"
  ["glow"]="🌟 Glow (Renderizador de Markdown no terminal)"
  ["gobang"]="🗃️ gobang (Cross-platform Database Client TUI)"
  ["gojq"]="🔍 gojq (Implementação pura em Go do jq)"
  ["gorilla-cli"]="🦍 gorilla-cli (LLMs para CLI)"
  ["gping"]="🏓 gping (Ping com gráfico)"
  ["gptme"]="🤖 gptme (CLI AI agent)"
  ["grex"]="🧠 grex (Gerador de regex)"
  ["gron"]="🔧 gron (Torna o JSON buscável via grep)"
  ["grpcurl"]="📡 grpcurl (Como o curl mas para servidores gRPC)"
  ["grype"]="🔒 grype (Scanner de vulnerabilidade para imagens e sistemas de arquivos)"
  ["gtt"]="🌐 gtt (Google Translate TUI)"
  ["gum"]="🍬 gum (Glamorous shell scripts)"
  ["hadolint"]="🐳 hadolint (Linter para Dockerfile)"
  ["harlequin"]="🎩 Harlequin (SQL IDE for terminal)"
  ["hck"]="📦 hck (A sharp cut(1) clone)"
  ["helix"]="🧬 Helix (Post-modern text editor)"
  ["helm"]="⎈ helm (Gerenciador de pacotes para Kubernetes)"
  ["heroku"]="☁️ Heroku CLI (Gerenciar plataformas Heroku)"
  ["hexyl"]="🔢 hexyl (Visualizador hexadecimal no terminal)"
  ["howdoi"]="❓ howdoi (Respostas instantâneas de código)"
  ["htmlq"]="📄 htmlq (jq para HTML)"
  ["htop"]="📊 htop (Interactive process viewer)"
  ["httpie"]="🌐 httpie (Cliente HTTP moderno)"
  ["httpstat"]="📊 httpstat (Visualização de estatísticas do curl)"
  ["httpx"]="⚡ httpx (Toolkit HTTP rápido)"
  ["hurl"]="🎯 hurl (Executa requisições HTTP definidas em formato de texto)"
  ["hwatch"]="👀 hwatch (Alternativa moderna ao watch)"
  ["hyperfine"]="⏱️ Hyperfine (Utilitário de benchmarking em terminal)"
  ["igrep"]="🔎 igrep (Grep interativo)"
  ["infisical"]="🔐 Infisical (Gerenciamento de segredos Open Source)"
  ["infracost"]="💰 infracost (Estimativas de custos na nuvem para Terraform)"
  ["inlyne"]="🖥️ inlyne (Visualizador markdown via GPU)"
  ["inshellisense"]="💡 Inshellisense (Autocomplete estilo IDE para shells)"
  ["jan"]="🤖 Jan (Alternativa local ao ChatGPT)"
  ["jaq"]="🔍 jaq (Clone do jq focado em correção/velocidade/simplicidade)"
  ["jc"]="🔧 jc (Converte saída de comandos para JSON)"
  ["jira-cli"]="🎫 jira-cli (Jira command line)"
  ["jj"]="🐙 jj (Alternativa ao Git com foco em usabilidade)"
  ["jless"]="🔍 Jless (Visualizador JSON para linha de comando)"
  ["jnv"]="🔍 jnv (Frontend interativo para jq)"
  ["jo"]="🔧 jo (Utilitário para gerar saídas JSON)"
  ["joshuto"]="📁 joshuto (Gerenciador de arquivos para terminal escrito em Rust)"
  ["jq"]="🔍 jq (Processador JSON de linha de comando)"
  ["jql"]="🔍 jql (Processador CLI para linguagem de consulta JSON)"
  ["jqp"]="🔍 jqp (TUI interativa para testar consultas jq)"
  ["jujutsu"]="🥋 jujutsu (Sistema de controle de versão compatível com Git)"
  ["just"]="🤖 Just (Executor de comandos simplificado)"
  ["k3d"]="🐳 k3d (Kubernetes leve rodando no Docker)"
  ["k3s"]="☸️ k3s (Kubernetes leve para edge computing)"
  ["k6"]="🚀 k6 (Utilitário moderno de testes de carga)"
  ["k8sgpt"]="☸️ k8sgpt (IA diagnosticando problemas no Kubernetes)"
  ["k9s-cli"]="🐶 k9s-cli (Kubernetes CLI TUI)"
  ["kakoune"]="🚀 kakoune (Better Vim)"
  ["kalker"]="🧮 kalker (Calculadora com suporte a matemática avançada)"
  ["kaskade"]="🌊 kaskade (Interface TUI para Kafka)"
  ["kcl"]="📝 kcl (KCL Configuration Language)"
  ["kdash"]="☸️ kdash (Dashboard do Kubernetes no terminal)"
  ["kind"]="🐳 kind (Kubernetes rodando em containers Docker)"
  ["klog"]="⏱️ klog (Rastreador de tempo baseado em texto puro)"
  ["kmon"]="🐧 kmon (Gerenciador e monitor de kernel do Linux)"
  ["ko"]="📦 ko (Build e deploy de imagens contêiner para Go)"
  ["kondo"]="🧹 kondo (Limpeza de artefatos em projetos de software)"
  ["krew"]="🔌 krew (Gerenciador de plugins para kubectl)"
  ["kubecolor"]="🎨 kubecolor (Adiciona cores a saída do kubectl)"
  ["kubectl"]="⎈ kubectl (Cliente de linha de comando para Kubernetes)"
  ["kubectx"]="⎈ kubectx (Muda rapidamente entre contextos do Kubernetes)"
  ["kubens"]="📦 kubens (Muda rapidamente entre namespaces do Kubernetes)"
  ["kubent"]="☸️ kubent (Verificador de uso de APIs descontinuadas do Kubernetes)"
  ["kustomize"]="🛠️ kustomize (Gerenciador de configuração Kubernetes nativo)"
  ["lapce"]="⚡ Lapce (Lightning-fast Code Editor in Rust)"
  ["lazydocker"]="🐳 LazyDocker TUI (Contêineres com Estilo)"
  ["lazygit"]="🐙 lazygit (Simple terminal UI for git commands)"
  ["lazygit-tui"]="🐙 lazygit-tui TUI (Git feito certo)"
  ["lazynpm"]="📦 Lazynpm (Interface TUI para NPM)"
  ["lazysql"]="🦥 Lazysql (SQL Client TUI)"
  ["lazyvim"]="💤 lazyvim (Neovim starter)"
  ["lefthook"]="🪝 lefthook (Gerenciador de hooks do Git rápido)"
  ["lens"]="👁️ lens (IDE focado no Kubernetes)"
  ["lf"]="📁 lf (Gerenciador de arquivos de terminal estilo Ranger)"
  ["litecli"]="🗃️ litecli (SQLite CLI with auto-completion and syntax highlighting)"
  ["llm"]="🧠 LLM (Acesso a grandes modelos de linguagem via CLI)"
  ["lmstudio"]="🤖 LM Studio (Rode LLMs locais com interface gráfica)"
  ["lnav"]="📋 lnav (Navegador e visualizador de arquivos de log)"
  ["lsd"]="🌟 lsd (Substituto moderno para ls)"
  ["lychee"]="🔗 lychee (Verificador de links rápido)"
  ["macchina"]="💻 macchina (Buscador rápido de informações do sistema)"
  ["mani"]="📂 mani (Utilitário CLI para gerenciar múltiplos repositórios)"
  ["marimo"]="📓 marimo (Notebooks Python reativos)"
  ["mcfly"]="🧠 mcfly (Navegador inteligente de histórico do shell)"
  ["mdcat"]="🐈 mdcat (Visualizador de markdown no terminal)"
  ["melt"]="🔑 melt (Gera seed words para chaves SSH)"
  ["micro"]="🚀 micro (Editor de texto de terminal intuitivo)"
  ["miller"]="📊 miller (Como o jq mas para arquivos de dados tabulares)"
  ["miniserve"]="🗄️ miniserve (Servidor de arquivos local simples e rápido)"
  ["mise"]="🛠️ Mise (Gerenciador de versões poliglota)"
  ["mkcert"]="🔐 mkcert (Utilitário simples para certificados locais confiáveis)"
  ["mlr"]="📊 mlr (Alias para miller - utilitário para dados tabulares)"
  ["moar"]="📄 moar (Pager melhorado para visualização de texto)"
  ["mods"]="🤖 Mods (Assistente de IA integrado na linha de comando)"
  ["monolith"]="📦 monolith (Salva páginas web completas em um único arquivo)"
  ["moon"]="🌙 Moon (Sistema de build rápido para repositórios JS/TS)"
  ["mprocs"]="🔄 mprocs (Executa múltiplos comandos em paralelo com TUI)"
  ["mycli"]="🐬 mycli (MySQL CLI with auto-completion and syntax highlighting)"
  ["mysql"]="🐬 MySQL Server & Client (Bancos de Dados)"
  ["nap"]="😴 nap (Gerenciador de snippets via linha de comando)"
  ["navi"]="🧭 navi (Cheatsheet interativa para linha de comando)"
  ["ncdu"]="🚀 ncdu (Analisador de uso de disco baseado em Ncurses)"
  ["ncspot"]="🎵 ncspot (Cliente Spotify de terminal cruzado)"
  ["neofetch-alt"]="⚡ neofetch-alt (Modern System Info)"
  ["neovim"]="📝 Neovim (Editor de texto avançado)"
  ["netlify"]="▲ Netlify CLI (Deploy and manage sites)"
  ["newsboat"]="📰 newsboat (Leitor de feeds RSS/Atom para terminal)"
  ["ngrok"]="🚇 ngrok (Criação de túneis seguros para localhost)"
  ["nix"]="❄️ Nix (Gerenciador de pacotes multi-plataforma moderno)"
  ["nnn"]="🚀 nnn (Gerenciador de arquivos de terminal extremamente rápido)"
  ["nomad"]="🚀 Nomad (Orquestrador de workloads da HashiCorp)"
  ["nuclei"]="⚡ nuclei (Scanner rápido de vulnerabilidades em alvos)"
  ["numbat"]="🧮 numbat (Calculadora científica de alta precisão com unidades)"
  ["nushell"]="🐚 Nushell (Shell moderno estruturado em dados)"
  ["obsidian"]="📓 Obsidian (Second Brain & Notas)"
  ["oh-my-posh"]="🎨 oh-my-posh (Prompt theme engine)"
  ["oha"]="📈 Oha (Ferramenta TUI para benchmark HTTP)"
  ["ollama"]="🦙 Ollama (Rode LLMs localmente)"
  ["onefetch"]="📊 onefetch (Resumo do projeto Git no terminal)"
  ["open-interpreter"]="🤖 Open-Interpreter (LLM que executa código localmente)"
  ["opentofu"]="🏗️ OpenTofu (Alternativa open-source ao Terraform)"
  ["ouch"]="🗜️ ouch (Ferramenta de compressão e descompressão sem dor de cabeça)"
  ["oxker"]="🐳 oxker (TUI simples para visualizar e controlar contêineres docker)"
  ["oxlint"]="🐂 oxlint (Linter ultrarrápido para JavaScript e TypeScript)"
  ["packer"]="📦 Packer (Construtor de imagens automatizadas da HashiCorp)"
  ["pastel"]="🎨 pastel (Utilitário de cores para linha de comando)"
  ["peco"]="🔍 peco (Utilitário interativo e simplista para filtragem)"
  ["pgcli"]="🐘 pgcli (Postgres CLI with auto-completion and syntax highlighting)"
  ["pipes-rs"]="🚰 pipes-rs (Animated pipes terminal screensaver)"
  ["pipes-sh"]="🚰 pipes-sh (Animated pipes screensaver)"
  ["pixi"]="📦 pixi (Gerenciador de pacotes rápido focado em Python e C++)"
  ["pkgx"]="📦 pkgx (Gerenciador de pacotes que roda qualquer coisa sem instalar)"
  ["plandex"]="🤖 Plandex (Motor de codificação assistido por IA de código aberto)"
  ["pls"]="🤖 pls (Assistente CLI aprimorado por IA)"
  ["pnpm"]="📦 pnpm (Gerenciador de pacotes Node.js rápido e eficiente no uso de disco)"
  ["podman"]="🦭 Podman (Daemonless container engine)"
  ["poetry"]="📦 poetry (Gerenciamento de dependências e empacotamento em Python)"
  ["pokeget"]="👾 pokeget (Mostra sprites de Pokémon no terminal)"
  ["pomsky"]="🐾 pomsky (Linguagem elegante e alternativa ao regex)"
  ["popeye"]="👀 popeye (Sanitizador de recursos de cluster Kubernetes)"
  ["porsmo"]="🍅 porsmo (Temporizador Pomodoro simples via CLI)"
  ["posting"]="📮 Posting (HTTP Client TUI)"
  ["presenterm"]="📽️ presenterm (Apresentações de slides em Markdown no terminal)"
  ["procs"]="🔍 Procs (Substituto moderno e colorido para o comando ps)"
  ["proto"]="🔧 proto (Gerenciador de versões plugável e de próxima geração)"
  ["pueue"]="🗃️ Pueue (Gerenciador de tarefas via linha de comando)"
  ["pulumi"]="🏗️ Pulumi (Plataforma de infraestrutura como código usando linguagens de programação reais)"
  ["px"]="📊 px (Alternativa amigável aos comandos ps e top)"
  ["qsv"]="📊 qsv (Conjunto de utilitários para manipulação de dados CSV)"
  ["repomix"]="📦 Repomix (Empacota repositório de código para consumo por IA)"
  ["rio"]="🎨 Rio (Emulador de terminal acelerado por GPU)"
  ["rip"]="🗑️ rip (Alternativa segura e ergonômica ao comando rm)"
  ["ripgrep"]="⚡ Ripgrep (Buscador orientado a linha ultra rápido)"
  ["ripgrep_all"]="📦 ripgrep_all (Busca em PDFs/E-Books/Documentos do Office)"
  ["rnr"]="🔄 rnr (Utilitário seguro para renomear arquivos e diretórios)"
  ["rs-cmatrix"]="💻 rs-cmatrix (Chuva de matriz recriada em Rust)"
  ["ruff"]="⚡ Ruff (Linter em Python extremamente rápido feito em Rust)"
  ["ruplacer"]="🔄 ruplacer (Busca e substituição rápida de texto em arquivos de origem)"
  ["rustscan"]="🔍 rustscan (Scanner de portas incrivelmente rápido)"
  ["rye"]="🌾 Rye (Experiência e gerenciamento sem atrito para Python)"
  ["sad"]="😢 sad (Substituição de texto em lote estilo sed/awk)"
  ["scc"]="📊 scc (Contador rápido de linhas de código)"
  ["sd"]="🔍 sd (Alternativa intuitiva de busca e substituição ao sed)"
  ["serie"]="📈 serie (Visualizador rico de gráfico de commits do Git via CLI)"
  ["serpl"]="🔍 serpl (Interface de terminal interativa para busca e substituição)"
  ["sesh"]="🖥️ sesh (Gerenciador de sessões inteligente para o terminal)"
  ["shell-gpt"]="💬 Shell-GPT (Assistente ChatGPT via linha de comando)"
  ["shellcheck"]="🐚 shellcheck (Analisador estático para shell scripts)"
  ["shfmt"]="✨ shfmt (Formatador/parser e interpretador de shell script)"
  ["silicon"]="📸 silicon (Gera imagens elegantes e personalizáveis de código-fonte)"
  ["skate"]="🔑 skate (Armazenamento pessoal estilo chave-valor na linha de comando)"
  ["skim"]="🔍 skim (Buscador aproximado rápido feito em Rust)"
  ["slack"]="💬 Slack Desktop (Comunicação)"
  ["slides"]="📊 slides (Apresentações baseadas em terminal)"
  ["slumber"]="😴 Slumber (Cliente de API HTTP baseado em terminal focado em usabilidade)"
  ["sniffnet"]="🕸️ sniffnet (Monitor de tráfego de rede multiplataforma para terminal)"
  ["so"]="🔍 so (Busque e leia respostas do StackOverflow no terminal)"
  ["sops"]="🔐 sops (Utilitário simples e flexível para gerenciar segredos)"
  ["spacer"]="📏 spacer (Insere espaçadores em saídas do terminal)"
  ["spt"]="🎵 spt (Interface de terminal completa para o Spotify)"
  ["sqlc"]="🗄️ sqlc (Compilador de código type-safe a partir de SQL)"
  ["starship"]="🚀 Starship Prompt (Synthwave '84 ativado)"
  ["steampipe"]="☁️ steampipe (Consulta e interage com infraestrutura na nuvem usando SQL)"
  ["stern"]="📋 stern (Tailing rápido de logs de múltiplos pods e contêineres no Kubernetes)"
  ["stripe"]="💳 Stripe CLI (Interface de linha de comando para testar APIs da Stripe)"
  ["supabase"]="⚡ supabase (Ferramenta de linha de comando oficial do Supabase)"
  ["superfile"]="📁 Superfile (Terminal File Manager)"
  ["syft"]="📦 syft (Gerador de SBOM via CLI)"
  ["systemctl-tui"]="⚙️ systemctl-tui (TUI simples e rápida para gerenciar serviços systemd)"
  ["systeroid"]="🧠 systeroid (Alternativa moderna e mais poderosa ao sysctl com interface TUI)"
  ["sysz"]="⚙️ sysz (Interface fzf baseada no terminal para o systemctl)"
  ["t-rec"]="📼 t-rec (Gravador de terminal super rápido que gera GIFs)"
  ["tailspin"]="🪵 tailspin (Destaque e visualização elegante de logs via linha de comando)"
  ["taplo"]="⚙️ taplo (Conjunto de utilitários para arquivos TOML)"
  ["task"]="✅ task (Alternativa moderna baseada em YAML ao comando Make)"
  ["taskwarrior-tui"]="✅ taskwarrior-tui (Interface de terminal amigável para o Taskwarrior)"
  ["tealdeer"]="🦌 Tealdeer (Implementação super rápida em Rust do TLDR)"
  ["television"]="📺 television (Buscador aproximado incrivelmente rápido via TUI)"
  ["tenki"]="⛅ tenki (Previsão do tempo bela e rápida exibida no terminal)"
  ["tenv"]="🌍 tenv (Gerenciador de versão simplificado para ferramentas IaC)"
  ["tere"]="🚀 tere (Alternativa mais rápida e minimalista para comandos cd e tree)"
  ["termdbms"]="🗄️ termdbms (Interface de terminal para visualizar dados de bancos relacionais)"
  ["termscp"]="📁 termscp (Explorador e cliente de transferência de arquivos de terminal)"
  ["termshark"]="🦈 termshark (Interface TUI inspirada no Wireshark para análise de pacotes)"
  ["termtyper"]="⌨️ termtyper (Teste de digitação interativo e estético no terminal)"
  ["terragrunt"]="🏗️ Terragrunt (Envolucro leve para Terraform)"
  ["tflint"]="🔍 TFLint (Terraform linter)"
  ["tfsec"]="🛡️ tfsec (Scanner de segurança estático para código Terraform)"
  ["tgpt"]="🤖 tgpt (Cliente do ChatGPT integrado direto no terminal sem chaves de API)"
  ["thefuck"]="🤬 thefuck (Corrige comandos digitados erroneamente)"
  ["tickrs"]="📈 tickrs (Visualização em tempo real de ações e dados de mercado via TUI)"
  ["tig"]="🚀 tig (Interface elegante em modo texto focado em visualização de Git)"
  ["tilt"]="🛠️ tilt (Ambiente de desenvolvimento unificado e automatizado para Kubernetes)"
  ["tin-summer"]="☀️ tin-summer (Buscador rápido de artefatos de build inúteis pesando no disco)"
  ["tldr"]="📚 tldr (Cheatsheets colaborativas e simplificadas de comandos via console)"
  ["tlrc"]="📚 tlrc (Cliente oficial super rápido do tldr escrito em Rust)"
  ["tmate"]="🤝 tmate (Compartilhamento seguro e instantâneo de sessões de terminal via web)"
  ["tmux"]="🪟 tmux (Multiplexador de terminal poderoso e customizável)"
  ["tokei"]="⏰ Tokei (Utilitário que gera estatísticas detalhadas de código fonte incrivelmente rápido)"
  ["topgrade"]="🚀 topgrade (Comando único para atualizar quase tudo em seu sistema)"
  ["trash-cli"]="🗑️ trash-cli (Interface amigável para envio de arquivos à lixeira do sistema de forma segura)"
  ["tre"]="🌲 tre (Comando alternativo de exibição em árvore altamente melhorado)"
  ["trippy"]="🗺️ trippy (Ferramenta poderosa para diagnosticar e visualizar conectividade de rede)"
  ["trivy"]="🛡️ trivy (Scanner integrado de vulnerabilidades cobrindo contêineres/código/e IaC)"
  ["trufflehog"]="🐷 trufflehog (Utilitário rápido para escanear repositórios atrás de segredos expostos)"
  ["trzsz"]="📤 trzsz (Transferência de arquivos simples compatível com tmux)"
  ["tt"]="⌨️ tt (Teste limpo e minimalista de digitação direto no terminal)"
  ["ttyd"]="🌐 ttyd (Transforma comandos CLI em aplicativos visuais de terminal hospedados na web)"
  ["ttyper"]="⌨️ ttyper (Outro utilitário elegante de terminal para testes de velocidade de digitação)"
  ["turso"]="🗄️ turso (Cliente oficial para o banco de dados e plataforma Turso em edge)"
  ["typos"]="📝 typos (Verificador ortográfico hiper-rápido para código fonte)"
  ["typos-cli"]="📝 typos-cli (Cliente do corretor ortográfico Typos)"
  ["typst"]="📝 typst (Alternativa ao LaTeX mais simples usando formatação baseada em marcação)"
  ["ugit"]="⏪ ugit (Utilitário CLI interativo desenhado para desfazer facilmente comandos Git executados)"
  ["ugrep"]="🔍 ugrep (Alternativa ultra rápida ao grep trazendo uma interface TUI interativa)"
  ["usql"]="🗄️ usql (Cliente de banco de dados universal para terminal)"
  ["uv"]="🐍 uv (Gerenciador Python ultrarrápido em Rust)"
  ["vault"]="🔐 Vault (Gerenciamento seguro de segredos e infraestrutura de chave da HashiCorp)"
  ["vcluster"]="⎈ vcluster (Cria clusters virtuais leves no topo de clusters Kubernetes normais)"
  ["vegeta"]="🔫 vegeta (Testes de carga HTTP e biblioteca)"
  ["vercel"]="▲ Vercel CLI (Deploy de aplicações serverless)"
  ["vhs"]="📼 vhs (Gravador configurável via texto de terminal gerando GIFs perfeitos)"
  ["viddy"]="⌚ viddy (Versão moderna e aprimorada com controle de tempo do clássico utilitário watch)"
  ["visidata"]="📊 visidata (Planilha multiferramenta de terminal)"
  ["viu"]="🖼️ viu (Visualizador super simples de imagens renderizadas no terminal em Rust)"
  ["vivid"]="🌈 vivid (Gerador que cria um esquema LS_COLORS moderno a partir de temas elegantes)"
  ["vscode"]="💻 Visual Studio Code (Setup Moderno)"
  ["walk"]="🚶 walk (Navegador e gerenciador de arquivos rápido com navegação baseada em visualização prévia)"
  ["warp"]="⚡ Warp Terminal (AI & GPU Acelerado)"
  ["watchexec"]="👀 watchexec (Execute comandos de terminal e reinicie aplicativos ao salvar ou modificar arquivos)"
  ["waypoint"]="🎯 waypoint (Deploy moderno de aplicações)"
  ["websocat"]="🌐 websocat (Poderoso utilitário tipo netcat para websockets e proxies bidirecionais)"
  ["wezterm"]="💻 WezTerm (Emulador de terminal acelerado por GPU)"
  ["wiki-tui"]="📖 wiki-tui (Visualizador de artigos do Wikipedia através de uma TUI rápida escrita em Rust)"
  ["windsurf"]="🏄 Windsurf (AI IDE da Codeium)"
  ["wtf"]="🖥️ wtf (Painel modular e altamente personalizável para exibir informações no terminal)"
  ["wtfutil"]="🖥️ wtfutil (Painel modular e altamente personalizável para exibir informações no terminal)"
  ["wthrr"]="🌦️ wthrr (Previsão do tempo estilosa gerada no terminal (apelidada de Weather Crab))"
  ["wthrr-the-weathercrab"]="🌦️ wthrr-the-weathercrab (Previsão do tempo estilosa gerada no terminal)"
  ["wuzz"]="🌐 wuzz (Utilitário CLI interativo para inspeção HTTP)"
  ["xc"]="📝 xc (Utilitário de linha de comando para executar tarefas criadas dentro de arquivos Markdown)"
  ["xcp"]="🚀 xcp (Uma alternativa ao clássico utilitário de cópia cp estendida e construída em Rust)"
  ["xh"]="🌐 xh (Utilitário rápido e amigável para requests HTTP)"
  ["xplr"]="📁 xplr (Um gerenciador e explorador de arquivos muito rápido que usa as teclas padrão estilo VIM)"
  ["xsv"]="📊 xsv (Conjunto de utilitários de alta performance para CSV)"
  ["yamlfmt"]="✨ yamlfmt (Formatador extensível para arquivos YAML)"
  ["yazi"]="🦆 Yazi File Manager (Arquivos na velocidade da luz)"
  ["yq"]="🔍 yq (Processador portátil de terminal do tipo jq focado no parsing de conteúdo YAML)"
  ["yt-dlp"]="🎥 yt-dlp (Video downloader)"
  ["zed"]="💻 Zed Editor (Escrito em Rust)"
  ["zellij"]="🪟 Zellij Terminal Multiplexer (Workspace Moderno)"
  ["zen-browser"]="🌐 Zen Browser (Navegador ultrarrápido focado em privacidade)"
  ["zenith"]="📈 zenith (Monitor detalhado do uso de hardware no terminal usando gráficos em tempo real)"
  ["zig"]="⚡ Zig (Modern programming language)"
  ["zizmor"]="🛡️ zizmor (Análise estática para GitHub Actions)"
  ["zoxide"]="🚀 Zoxide (A smarter cd command)"
  ["zrok"]="🔗 zrok (Solução open source alternativa ao ngrok baseada no OpenZiti para tunelamento local)"
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
    --selected.background="#ff7edb" \
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
