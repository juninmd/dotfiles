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
      --align center --margin "1 2" --padding "3 5" \
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
      --align left --margin "1 2" --padding "3 5" \
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
      --align left --margin "1 2" --padding "2 3" \
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
      --padding "1 2" --margin "1 0" --align center \
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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun mysql lazygit-tui lazydocker ghostty zellij yazi neovim docker uv mise atuin devbox dagger deno biome ruff broot procs pueue glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aichat duckdb lazysql harlequin fastfetch turbo entr doggo tokei jless oha curlie fabric k8sgpt tgpt jan chatbox inshellisense podman devpod daytona just mods llm helix nushell opentofu distrobox moon cline doppler pulumi vault waypoint boundary kubeshark chatblade)
    ;;
  full)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lm-studio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce fastfetch kew gaze dnote lolcat asciinema agg iredis mitmproxy turbo entr common kubeshark chatblade)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp ghostty lazygit-tui lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lm-studio bruno wezterm dbeaver windsurf k9s-cli posting superfile aider plandex open-interpreter duckdb harlequin neofetch-alt lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aider-chat trippy onefetch grex bandwhich amber tailspin erdtree dua oxlint difftastic topgrade pastel numbat dufs jj sesh carapace moar vhs gitleaks xc gdu trash-cli yt-dlp glances d2 pnpm fnm gping kondo presenterm hexyl csvlens pomsky bacon wiki-tui ast-grep dive gron viddy wtfutil cointop dasel dust navi delta websocat ouch zenith git-cliff typos fend joshuto sniffnet termscp wthrr miniserve zizmor inlyne so xcp taplo tlrc typst xsv gh act task croc dbmate ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next gptme ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce tmux htop cmatrix vivid hadolint ugit pgcli mycli litecli tere kubent lazyvim oh-my-posh micro nnn tig ncdu kakoune hck termshark kmon poetry fastfetch serie eget skate checkov freeze binsider distrobox tenv mkcert dprint steampipe dua-cli ttyper rs-cmatrix systeroid lefthook vscode klog grpcurl dotenv-linter just obsidian flyctl turso kubecolor ko vcluster visidata syft asciinema agg iredis mitmproxy turbo entr common stern popeye qsv cheat silicon age peco cocogitto termtyper android git-absorb ngrok charm jira-cli bat-extras genact cpufetch lnav ghq pokeget ctop git-town hurl actionlint ugrep mdcat jc nuclei wuzz httpstat gojq lychee kalker httpie sqlc htmlq sysz chafa fq px melt kubectx termdbms dolt dapr xh newsboat jujutsu thefuck rnr monolith serpl fx shellcheck tickrs mysql cloudflared scc evans watchexec direnv dura kustomize czg git-filter-repo kubectl hyperfine bore-cli pkgx glab helix gh-dash httpx diskonaut porsmo trufflehog usql tenki sops pipes-rs trivy shfmt infracost flox duf kind dysk howdoi vegeta skim gum firefox k3d tin-summer krew yamlfmt jq ncspot oxker moon nushell taskwarrior-tui discord rip dnote yq hwatch tilt slack mani chatgpt-cli gaze brave jnv dotenvx devenv tfsec tealdeer grype tre jaq slides systemctl-tui sad kew rustscan spacer miller bluetuith viu atlas gtt trzsz ruplacer crane lolcat gcloud jqp earthly jql opentofu igrep tldr lf tt mcfly rye zrok helm supabase spt git-sim walk kubeshark chatblade)
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
  ["kubeshark"]="🦈 Analisador de tráfego de API para Kubernetes"
  ["chatblade"]="💬 Canivete suíço em CLI para ChatGPT"

  ["act"]="🎬 Executa GitHub Actions localmente"
  ["actionlint"]="🛠️ Linter estático para GitHub Actions"
  ["age"]="🔐 Criptografia de arquivos simples e moderna"
  ["agg"]="🎬 Converte gravações asciinema (.cast) em GIFs incríveis otimizados e hiper-rápidos em rust"
  ["aichat"]="🤖 Cliente CLI p/ dezenas de LLMs"
  ["aider"]="💻 Pair programming via AI no terminal"
  ["aider-chat"]="💻 Pair programming AI"
  ["amber"]="🔍 Busca de texto ultra rápida"
  ["android"]="📱 Ferramentas de SDK Android"
  ["aqua"]="📦 Gerenciador de ferramentas declarativo"
  ["argc"]="⚡ Criação de CLIs a partir de comentários em bash"
  ["argocd"]="🐙 CD declarativo para Kubernetes"
  ["asciinema"]="🎥 Grava e compartilha sessões de terminal online de forma super leve em texto puro"
  ["ast-grep"]="🌳 Busca e reescrita de código baseada em AST"
  ["atac"]="🌐 Postman em TUI rápido"
  ["atlas"]="🗄️ CLI de banco de dados moderno"
  ["atuin"]="🐢 Sincroniza e busca no histórico do shell"
  ["awscli"]="☁️ Interface oficial para Amazon Web Services"
  ["bacon"]="🥓 Monitor de compilação em background para Rust"
  ["bandwhich"]="📶 Mostra utilização de rede por processo"
  ["bat"]="🦇 Clone do cat com syntax highlighting"
  ["bat-extras"]="🦇 Scripts adicionais para o bat"
  ["binsider"]="🔬 Analisador de binários Linux em TUI"
  ["biome"]="🌍 Formatter e linter hiper-rápido para Web"
  ["bito"]="🧠 Assistente de código AI"
  ["bluetuith"]="🦷 Gerenciador de Bluetooth TUI"
  ["bore-cli"]="🚇 Túneis TCP locais simplificados"
  ["bottom"]="📉 Monitor de sistema gráfico (btm)"
  ["boundary"]="🛡️ Gerenciamento de acesso seguro"
  ["brave"]="🦁 Navegador Brave (Privacy-first)"
  ["broot"]="🌲 Navegação em árvore de diretórios rápida"
  ["bruno"]="🐶 Cliente de API alternativo ao Postman"
  ["bruno-cli"]="🐶 CLI do cliente de API Bruno"
  ["btop"]="📊 Monitor de recursos TUI moderno"
  ["bun"]="🍞 Runtime JS ultra rápido"
  ["bw"]="🔐 Bitwarden CLI"
  ["carapace"]="🐚 Autocomplete multi-shell"
  ["cbonsai"]="🪴 Gerador de bonsai no terminal"
  ["chafa"]="🖼️ Visualizador de imagens em terminal gráfico"
  ["charm"]="✨ Ferramentas TUI da Charmbracelet"
  ["chatbox"]="💬 Cliente desktop para LLMs"
  ["chatgpt-cli"]="🤖 ChatGPT diretamente do terminal"
  ["cheat"]="📄 Cheatsheets interativos no terminal"
  ["checkov"]="🛡️ Linter para Infraestrutura as Code"
  ["choose"]="✂️ Alternativa ao cut e awk mais simples"
  ["circumflex"]="📰 Leitor de Hacker News em TUI"
  ["claude-code"]="🤖 Agente de programação da Anthropic"
  ["cli-tools"]="🛠️ Ferramentas base do sistema"
  ["cline"]="🤖 Agente AI CLI integrado"
  ["cloudflared"]="☁️ Cliente de túnel da Cloudflare"
  ["cmatrix"]="📟 Chuva digital do Matrix"
  ["cocogitto"]="📦 CLI para Conventional Commits"
  ["code2prompt"]="📜 Converte código para prompts de LLM"
  ["cointop"]="🪙 Monitor de criptomoedas TUI"
  ["common"]="🛠️ Dependências comuns do setup"
  ["consul"]="🌐 Service mesh e descoberta de serviços"
  ["cpufetch"]="🖥️ Ferramenta de info de CPU"
  ["crane"]="🏗️ Ferramenta para gerenciar imagens de container"
  ["croc"]="🐊 Transferência de arquivos fácil e segura"
  ["csvlens"]="📊 Visualizador de CSV em TUI"
  ["ctop"]="🐳 Top command para containers Docker"
  ["curlie"]="🌐 cURL com facilidades do HTTPie"
  ["cursor"]="💻 Editor de código orientado a IA"
  ["czg"]="📝 Utilitário Commitizen interativo"
  ["d2"]="📐 Linguagem declarativa de diagramas"
  ["dagger"]="🗡️ Pipelines CI/CD como código"
  ["dapr"]="🏗️ Runtime para aplicações distribuídas"
  ["dasel"]="🛠️ Consulta de JSON / YAML / TOML / XML"
  ["daytona"]="🌅 Ambientes de desenvolvimento na nuvem"
  ["dbeaver"]="🗃️ Cliente universal de banco de dados"
  ["dbmate"]="🗄️ Ferramenta de migração de banco de dados"
  ["delta"]="🔍 Formatador de diffs para Git"
  ["deno"]="🦕 Runtime moderno para JS e TS"
  ["devbox"]="📦 Ambientes dev isolados via Nix"
  ["devenv"]="🔧 Ambientes dev reproduzíveis"
  ["devpod"]="🐳 Codespaces locais em qualquer infra"
  ["devspace"]="🚀 Deploy e dev para Kubernetes"
  ["devtoy"]="🧰 Canivete suíço para desenvolvedores"
  ["difftastic"]="📝 Ferramenta de diff estrutural AST"
  ["direnv"]="🌿 Carregamento automático de variáveis de ambiente"
  ["discord"]="💬 Chat para gamers e comunidades"
  ["diskonaut"]="🌌 Navegador visual de espaço em disco"
  ["distrobox"]="📦 Containers Linux em qualquer distro"
  ["dive"]="🐳 Explorador de camadas de imagens Docker"
  ["dnote"]="📓 Bloco de notas cli instantâneo"
  ["docker"]="🐳 Plataforma de containers"
  ["doggo"]="🐶 Cliente DNS moderno e colorido"
  ["dolt"]="🗃️ Banco de dados SQL versionado como Git"
  ["doppler"]="🔐 Gerenciador de segredos e configurações"
  ["dotenv-linter"]="🧹 Linter de arquivos .env"
  ["dotenvx"]="🗝️ Gestão de arquivos .env com criptografia"
  ["dprint"]="⚡ Formatador de código plugável e veloz"
  ["dsq"]="🗄️ Executa SQL sobre arquivos de dados"
  ["dua"]="📊 Analisador interativo de espaço em disco"
  ["dua-cli"]="📊 Utilitário CLI para disk usage"
  ["duckdb"]="🦆 Banco de dados analítico in-process"
  ["duf"]="🖥️ Alternativa moderna ao df"
  ["dufs"]="📁 Servidor de arquivos estáticos simples"
  ["dura"]="💾 Auto-backup invisível para Git"
  ["dust"]="🧹 Alternativa intuitiva ao du (disk usage)"
  ["dysk"]="💾 Mostra info de discos montados em TUI"
  ["earthly"]="🌍 Build automation para CI"
  ["eget"]="⬇️ Downloader universal do GitHub Releases"
  ["elixir"]="💧 Linguagem de programação funcional"
  ["entr"]="🔄 Utilitário CLI purista e limpo pra rodar comandos automáticos na mudança arbitrária de arquivos"
  ["erdtree"]="🌳 Visualizador de disco e árvore moderno"
  ["evans"]="📞 Cliente gRPC interativo"
  ["eza"]="🌟 Alternativa moderna ao comando ls"
  ["fabric"]="🤖 Framework de prompts via CLI"
  ["fastfetch"]="⚡ Neofetch ultrarrápido em C"
  ["fd-find"]="🔎 Alternativa rápida e amigável ao find"
  ["fend"]="🧮 Calculadora científica com conversão"
  ["ffuf"]="🚀 Fuzzer rápido p/ web em Go"
  ["firefox"]="🦊 Navegador web Mozilla"
  ["flox"]="📦 Ambientes de pacote fáceis com Nix"
  ["flyctl"]="✈️ CLI oficial da Fly.io"
  ["fnm"]="🚀 Gerenciador rápido de versão Node.js"
  ["fq"]="🛠️ jq para dados binários e formatos variados"
  ["freeze"]="📸 Gera imagens de trechos de código via CLI"
  ["fx"]="🎨 Visualizador e processador JSON TUI"
  ["fzf"]="🔍 Buscador fuzzy de linha de comando"
  ["gaze"]="👁️ Executa comandos quando arquivos mudam"
  ["gcloud"]="☁️ CLI oficial do Google Cloud"
  ["gdu"]="📊 Analisador de disco rápido em Go"
  ["genact"]="🎭 Gerador de atividade falsa"
  ["gh"]="🐙 CLI oficial do GitHub"
  ["gh-dash"]="📊 Dashboard do GitHub em TUI"
  ["ghostty"]="👻 Emulador de terminal super rápido"
  ["ghq"]="📂 Gerencia repositórios locais Git"
  ["git-absorb"]="🧲 git commit --fixup automático"
  ["git-cliff"]="⛰️ Gerador de changelog configurável"
  ["git-filter-repo"]="🧹 Reescreve histórico Git rapidamente"
  ["git-next"]="⏩ Fluxo de trabalho alternativo pro Git"
  ["git-sim"]="🎬 Simula comandos Git visualmente"
  ["git-town"]="🏙️ Fluxo de alto nível para o Git"
  ["gitingest"]="🧠 Extrai conteúdo de repositório para LLMs"
  ["gitleaks"]="🔑 Detecta segredos expostos em código"
  ["gitui"]="🖥️ Interface Git em TUI rápida e leve"
  ["glab"]="🦊 CLI oficial do GitLab"
  ["glances"]="👀 Monitoramento cruzado do sistema"
  ["gleam"]="✨ Linguagem segura na BEAM"
  ["glow"]="🌟 Leitor de Markdown em terminal"
  ["gobang"]="🗄️ Cliente de banco de dados TUI multiplataforma"
  ["gojq"]="🔍 Implementação pura de jq em Go"
  ["gorilla-cli"]="🦍 Gera comandos via IA com segurança"
  ["gping"]="🏓 Ping com gráficos coloridos no terminal"
  ["gptme"]="🤖 Assistente CLI LLM inteligente"
  ["grex"]="🔣 Gera regex a partir de strings de teste"
  ["gron"]="🧹 Transforma JSON em greppable"
  ["grpcurl"]="📞 cURL para serviços gRPC"
  ["grype"]="🛡️ Scanner de vulnerabilidades em containers"
  ["gtt"]="🌍 Tradutor do Google em terminal"
  ["gum"]="🍬 Ferramenta para UI em scripts bash"
  ["hadolint"]="🐳 Linter avançado para Dockerfile"
  ["harlequin"]="🃏 SQL IDE poderoso para o terminal"
  ["hck"]="🔪 Alternativa ao cut ultrarrápida"
  ["helix"]="🧬 Editor de texto modal pós-moderno"
  ["helm"]="🚢 Gerenciador de pacotes Kubernetes"
  ["heroku"]="☁️ CLI do Heroku"
  ["hexyl"]="🔢 Visualizador hexadecimal moderno"
  ["howdoi"]="❓ Busca de respostas diretas para devs"
  ["htmlq"]="🌐 jq para extrair conteúdo HTML"
  ["htop"]="📊 Visualizador de processos clássico e amigável"
  ["httpie"]="🌐 Cliente HTTP user-friendly alternativo cURL"
  ["httpstat"]="📈 Estatísticas de latência de curl visualmente"
  ["httpx"]="🌐 Toolkit HTTP multifuncional em Go"
  ["hurl"]="🌐 Executa requests HTTP via texto plano"
  ["hwatch"]="⌚ Watcher moderno de comandos iterativos"
  ["hyperfine"]="⏱️ Ferramenta de benchmarking CLI"
  ["igrep"]="🔍 Grep interativo em TUI"
  ["infisical"]="🔐 Gerenciador de segredos end-to-end"
  ["infracost"]="💰 Estimativas de custo para Terraform"
  ["inlyne"]="📉 Visualizador Markdown que suporta imagens"
  ["inshellisense"]="💡 Autocomplete superpoderoso tipo IDE"
  ["iredis"]="🗄️ Cliente Redis interativo purista focado em ter auto-complete e cores no terminal"
  ["jan"]="🤖 Cliente de IA local open-source"
  ["jaq"]="🔍 Clone do jq escrito em Rust"
  ["jc"]="🔧 Converte saída de CLIs para JSON"
  ["jira-cli"]="📋 Jira do terminal"
  ["jj"]="🛠️ Sistema de controle de versão moderno (Jujutsu)"
  ["jless"]="👀 Paginador e visualizador de JSON CLI"
  ["jnv"]="🔍 Filtro JSON iterativo interativo"
  ["jo"]="🛠️ Utilitário criador de JSON rápido"
  ["joshuto"]="📁 Gerenciador de arquivos CLI tipo ranger"
  ["jq"]="🔍 Processador JSON leve via CLI"
  ["jql"]="🔍 Processador JSON em Rust rápido"
  ["jqp"]="🛝 Playground TUI para queries jq"
  ["jujutsu"]="🛠️ Controle de versão (alias para jj)"
  ["just"]="🤖 Alternativa moderna ao Make"
  ["k3d"]="🐳 Roda o k3s no Docker"
  ["k3s"]="☸️ Kubernetes ultra leve e certificado"
  ["k6"]="🚀 Ferramenta de teste de carga HTTP"
  ["k8sgpt"]="🤖 Diagnóstico de Kubernetes usando IA"
  ["k9s-cli"]="🐶 Gerencia clusters Kubernetes via TUI"
  ["kakoune"]="📝 Editor modal baseado em seleção"
  ["kalker"]="🧮 Calculadora com sintaxe de matemática e variáveis"
  ["kaskade"]="🏄 Cliente interativo TUI Kafka"
  ["kcl"]="📐 Linguagem declarativa para infra"
  ["kdash"]="☸️ Dashboard de Kubernetes TUI minimalista"
  ["kew"]="🎧 Reprodutor de música terminal em C"
  ["kind"]="☸️ Kubernetes IN Docker"
  ["klog"]="⏱️ Rastreador de tempo em plain text"
  ["kmon"]="🐧 Monitor e explorador de Kernel Linux"
  ["ko"]="🐳 Construtor rápido de containers Go"
  ["kondo"]="🧹 Limpa artefatos (node_modules / target / etc)"
  ["krew"]="📦 Gerenciador de plugins para kubectl"
  ["kubecolor"]="🌈 Colore as saídas do kubectl"
  ["kubectl"]="☸️ Ferramenta de CLI Kubernetes oficial"
  ["kubectx"]="☸️ Alterna rapidamente contextos do kubectl"
  ["kubens"]="☸️ Alterna rapidamente namespaces no k8s"
  ["kubent"]="☸️ Verifica APIs depreciadas em clusters Kubernetes"
  ["kustomize"]="☸️ Gerenciamento de config Kubernetes s/ template"
  ["lapce"]="⚡ Editor de código rápido em Rust"
  ["lazydocker"]="🐳 TUI simples para Docker e Docker Compose"
  ["lazygit"]="📦 TUI veloz e imersiva para o Git"
  ["lazygit-tui"]="📦 TUI imersiva para Git (alias)"
  ["lazynpm"]="📦 TUI interativo para gerenciamento NPM"
  ["lazysql"]="🗄️ Cliente SQL e TUI cross-platform multi-bd"
  ["lazyvim"]="📝 Configuração rápida pro Neovim"
  ["lefthook"]="🪝 Gerenciador ultra-rápido de Git hooks"
  ["lens"]="🔎 IDE Kubernetes multiplataforma"
  ["lf"]="📁 Gerenciador de arquivos de terminal via C"
  ["litecli"]="🗄️ Cliente TUI para SQLite com autocomplete"
  ["llm"]="🤖 Utilitário CLI para executar LLMs locais ou remotos"
  ["lm-studio"]="🤖 Executa LLMs localmente via UI e API"
  ["lnav"]="🪵 Visualizador de logs com análise profunda"
  ["lolcat"]="🌈 Texto do terminal com efeito arco-íris"
  ["lsd"]="📂 Clone de ls moderno com cores e ícones"
  ["lychee"]="🔗 Verificador veloz de links quebrados"
  ["macchina"]="🖥️ Info básica do sistema ultraleve"
  ["mani"]="🗂️ CLI para gerenciamento multi repositórios"
  ["marimo"]="📓 Notebooks Python interativos e reativos"
  ["mcfly"]="🪰 Busca de histórico no shell com IA"
  ["mdcat"]="📖 Exibe formatação markdown direto no terminal"
  ["melt"]="🗝️ Backup e restauração SSH segura via seed"
  ["micro"]="📝 Editor de texto de terminal moderno e intuitivo"
  ["miller"]="📊 jq para CSV / TSV / tabular data"
  ["miniserve"]="🌐 Servidor estático rápido via CLI HTTP"
  ["mise"]="🛠️ Gerenciador multi versões (substituto do asdf)"
  ["mitmproxy"]="🌐 Interceptador proxy HTTPS/HTTP mágico purista e hackeável no terminal escrito em Python"
  ["mkcert"]="🔐 Cria certificados de dev locais facilmente"
  ["mlr"]="📊 Utilitário CLI miller para CSV (alias)"
  ["moar"]="👀 Um paginador superpoderoso (less substituto)"
  ["mods"]="🤖 IA interativa baseada em pipelines no terminal"
  ["monolith"]="📦 Empacota página web completa em arquivo HTML único"
  ["moon"]="🌕 Ferramenta de build multi-linguagens moderna"
  ["mprocs"]="⚙️ Roda múltiplos comandos concorrentes em TUI"
  ["mycli"]="🗄️ Cliente TUI para MySQL com autocomplete"
  ["mysql"]="🗃️ Banco de Dados Relacional"
  ["nap"]="📝 Gerenciador CLI de snippets de código"
  ["navi"]="🧭 Cheatsheets interativos direto no terminal"
  ["ncdu"]="📊 Analisador de espaço em disco rápido (C)"
  ["ncspot"]="🎵 Cliente Spotify TUI via CLI cruzada"
  ["neofetch-alt"]="🖥️ Sysinfo customizado com fastfetch"
  ["neovim"]="📝 Vim ultra-extensível reescrito"
  ["netlify"]="🌐 Plataforma de hospedagem Netlify CLI"
  ["newsboat"]="📰 Leitor de feed RSS / Atom para TUI"
  ["ngrok"]="🚇 Expõe ambiente local via túnel web"
  ["nix"]="❄️ Gerenciador de pacotes reprodutível global"
  ["nnn"]="📁 Gerenciador de arquivos ultra veloz no terminal"
  ["nomad"]="🏕️ Orquestrador de workloads da HashiCorp"
  ["nuclei"]="🔬 Scanner focado em templates de vulnerabilidade"
  ["numbat"]="📐 Calculadora poderosa e tipada cientificamente"
  ["nushell"]="🐚 Shell com dados em pipelines tipados modernos"
  ["obsidian"]="📓 Base de conhecimento em Markdown no Desktop"
  ["oh-my-posh"]="🌈 Engine de prompt configurável customizado"
  ["oha"]="🔫 Ferramenta de load testing HTTP baseada no hey"
  ["ollama"]="🦙 Servidor de IA LLMs para rodar localmente"
  ["onefetch"]="🐙 Sumário visual de repos Git via terminal"
  ["open-interpreter"]="🤖 Agente de IA para executar código no host"
  ["opentofu"]="🏗️ Fork OSS de gerenciador infra-as-code"
  ["ouch"]="🗜️ Compressor / descompressor super simples"
  ["oxker"]="🐳 Ferramenta simples para ver stats do Docker"
  ["oxlint"]="🧹 Linter veloz escrito em Rust para ecossistema JS"
  ["packer"]="📦 Automação de imagens de VM via HashiCorp"
  ["pastel"]="🎨 Ferramenta TUI para conversão de cores e esquemas"
  ["peco"]="🔍 Filtragem iterativa leve via TUI"
  ["pgcli"]="🐘 Cliente TUI para PostgreSQL com auto-complete"
  ["pipes-rs"]="🚰 Proteções de tela animadas em Rust"
  ["pipes-sh"]="🚰 Animação visual de tubos antigos em shell"
  ["pixi"]="📦 Gerenciador focado em Python e projetos base C/C++"
  ["pkgx"]="📦 Executor de binários direto da nuvem via npx-style"
  ["plandex"]="🤖 Agente de codificação complexa movido a IA"
  ["pls"]="📂 ls moderno em Python super elegante"
  ["pnpm"]="📦 Gerenciador de pacotes rápido e otimizado para Node"
  ["podman"]="🐳 Motor de containers sem necessidade de deamon raiz"
  ["poetry"]="📦 Gestão limpa de ambientes Python e pacotes"
  ["pokeget"]="🕹️ Pega sprites do Pokemon no terminal (TUI fun)"
  ["pomsky"]="🧩 Sintaxe portátil/ limpa e legível para Regex"
  ["popeye"]="👀 Scanner e analisador de erros em Kubernetes"
  ["porsmo"]="⏱️ CLI Pomodoro e temporizador via terminal TUI"
  ["posting"]="🌐 Postman em TUI veloz e poderoso para devs API"
  ["presenterm"]="📽️ Editor de slide apresentável direto pelo terminal"
  ["procs"]="📊 ps moderno focado em usabilidade com árvore em cores"
  ["proto"]="🛠️ Gestor de toolchains acoplável estilo asdf via Rust"
  ["pueue"]="🕒 Gerenciamento de tarefas shell longa duração / background"
  ["pulumi"]="☁️ Crie Infra as Code via linguagens como JS / Go / Python"
  ["px"]="📊 Monitor TUI moderno (ps / top / htop alternativo)"
  ["qsv"]="📊 Ferramenta absurdamente veloz para analisar e editar CSVs"
  ["repomix"]="📦 Mixagem de relatórios úteis gerados no seu repositório"
  ["rio"]="🌊 Terminal acelerado por GPU ultra veloz via Rust"
  ["rip"]="🗑️ Ferramenta de remoção de arquivos segura e recuperável"
  ["ripgrep"]="🔍 Grep hiper-veloz em Rust cruzando arquivos"
  ["ripgrep_all"]="🔍 Ripgrep turbinado incluindo busca de texto em PDF / docx"
  ["rnr"]="🏷️ Renomeação em massa para arquivos baseada em regex TUI"
  ["rs-cmatrix"]="📟 O CMatrix de sempre/ só que reescrito robustamente via Rust"
  ["ruff"]="⚡ O linter e formatador de Python mais rápido do oeste"
  ["ruplacer"]="🔄 Buscar e substituir no terminal sem medo e sem regex maluco"
  ["rustscan"]="📡 Mapeador de portas na velocidade da luz focado em auditorias"
  ["rye"]="🌾 Toolkit Python tudo-em-um (substituto pra pip/ venv/ pyenv)"
  ["sad"]="😢 Substitui texto CLI interativamente com preview via fzf estilo"
  ["scc"]="📈 Calculador ultra eficiente pra contagem de LOC / complexidade"
  ["sd"]="✂️ Substituto moderno do sed pra find-and-replace (sintaxe fácil)"
  ["serie"]="🪵 Visualizador TUI pra logs de git e historicos graficamente ricos"
  ["serpl"]="🔍 Ferramenta TUI veloz pra busca global e substituição rápida"
  ["sesh"]="🖇️ Gestor inteligente do tmux pra alternar e pular workspaces"
  ["shell-gpt"]="🤖 Usa a LLM da OpenAI (GPT) pra traduzir promts pra shell command"
  ["shellcheck"]="🧹 Analisador estático que não deixa seu script bash falhar e quebrar"
  ["shfmt"]="🧹 Formatação purista padronizada pra seus shellscripts / bash / zsh"
  ["silicon"]="📸 Tira screenshots esteticamente super agradáveis do teu codigozinho"
  ["skate"]="🗝️ Gestor e sicronizador kv TUI simples focado pra Charmbracelet"
  ["skim"]="🔍 Buscador Fuzzy alternativo super ligeiro escrito via pura Rust (sk)"
  ["slack"]="💬 Chat app global focado em comunicação assíncrona entre equipes"
  ["slides"]="📽️ Ferramenta mágica terminal baseada em Markdown pra apresentações"
  ["slumber"]="🌙 Cliente TUI REST API que foca em ergonomia de requests HTTP"
  ["sniffnet"]="📡 Visualiza interativamente todo o tráfego da sua network na tela"
  ["so"]="❓ Busca perguntas do stack overflow renderizando TUI sem navegador"
  ["sops"]="🔐 Editor CLI e criptografador moderno que interage com PGP e Cloud KMS"
  ["spacer"]="⏸️ Coloca espaçamentos utilitários cronometrados pra saídas contínuas"
  ["spt"]="🎵 TUI client pra escutar Spotify enquanto usa o neovim no mesmo env"
  ["sqlc"]="🗄️ Compilador estático robusto que traduz SQL pra type-safe code em Go"
  ["starship"]="🚀 Prompt minimalista e hyper flexivel compátivel com Bash/ ZSH e Fish"
  ["steampipe"]="☁️ Converte e consulta instantaneamente APIs Cloud pra queries em SQL"
  ["stern"]="🪵 Visualizador flexível pra tail em multi-pods logs do k8s com cores"
  ["stripe"]="💳 Utilitário terminal focado em debugar APIs da gateway de pgmt Stripe"
  ["supabase"]="⚡ CLI suite do Supabase pra criar e orquestrar infra de BaaS localmente"
  ["superfile"]="📁 Explorador terminal TUI focado com visual futurista muito bonito"
  ["syft"]="🔍 Gerador veloz de SBOM listando todas configs de pacote das imagens"
  ["systemctl-tui"]="⚙️ Administrador gráfico SystemD e control plane de serviços em terminal"
  ["systeroid"]="🧠 Visualizador TUI focado em kernel sysctl parameters config dinâmico"
  ["sysz"]="⚙️ Menu fzf focado em start/stop services do systemctl sem sofrimento"
  ["t-rec"]="🎥 Gravador simples terminal que exporta sessões fluidas em GIF nativo"
  ["tailspin"]="🪵 Pega logs brutos de servidor e injeta syntax highlight custom pra TUI"
  ["taplo"]="📝 Toolkit e linter mega rápido feito em rust pra ler e compilar arquivos TOML"
  ["task"]="🛠️ Executor simples em golang muito parecido com Make mas mais humano"
  ["taskwarrior-tui"]="✅ Controlador de TUDO interativo interface gráfica CLI pra taskwarrior"
  ["tealdeer"]="🦌 Cliente purista e mega rápido pra acessar comandos curtos do tldr pages"
  ["television"]="📺 Buscador rápido e minimalista com UI focada fuzzy focado rust backend"
  ["tenki"]="🌤️ App CLI simples e robusto focado em renderizar a previsão climática"
  ["tenv"]="📦 Version manager modular TUI pra infra Terraform/ OpenTofu/ e Terragrunt"
  ["tere"]="📁 Navegador purista pra achar caminhos e dar 'cd' incrivelmente rápido"
  ["termdbms"]="🗃️ TUI client e monitor focado pra múltiplos bancos relacionais sem frescura"
  ["termscp"]="🌐 TUI e painel pra transferir arquivos rápido via SCP/SFTP local vs remote"
  ["termshark"]="🦈 TUI shark focado em ler e interceptar tráfego PCAP (WireShark backend)"
  ["termtyper"]="⌨️ Teste TUI pra verificar sua velocidade/WPM digitando no term emulator"
  ["terragrunt"]="☁️ Wrapper mega útil pro terraform que padroniza os módulos/vars DRY config"
  ["tflint"]="🧹 Analisador purista que faz cross check de erros best practices em Terraform"
  ["tfsec"]="🛡️ Analisador focado pra achar brechas graves de segurança nos seus Terraform"
  ["tgpt"]="🤖 Acesso fácil à LLM e AI de conversação pelo terminal s/ precisar de API-Key"
  ["thefuck"]="🤬 Consertador autómato focado em digitar fuck e reescrever sua syntax errada"
  ["tickrs"]="📈 Painel financeiro focado em monitorar cripto e bolsas globais em realtime"
  ["tig"]="🌳 Interface baseada TUI focado na interatividade bruta usando git tree e git log"
  ["tilt"]="🚢 Moteur focado em dev containerizado local pra K8s (atualizações hot reload)"
  ["tin-summer"]="📊 Utilitário focado de du (disk space) q analisa recursivamente multiprocessamento"
  ["tldr"]="📖 Consulta rápida de cheatsheets em texto com exemplos práticos curtos CLI"
  ["tlrc"]="📖 Cliente purista de tldr escrito em rust super rápido com colors bonitas offline"
  ["tmate"]="🔗 Utilitário terminal focado em emulador remoto e proxy pra sessões SSH web"
  ["tmux"]="🪟 Multiplexador clássico focado em criar e manter panes/tabs terminal s/ limite"
  ["tokei"]="📊 Ferramenta contadora TUI focada ultra rápida pra saber as LOC das suas pastas"
  ["topgrade"]="🆙 CLI TUI pra detectar qual seu package manager nativo e atualizar TUDO d'uma vez"
  ["trash-cli"]="🗑️ Lixeira interativa com subcomandos TUI pra recuperar rm executado sem querer"
  ["tre"]="🌳 Variante moderna e inteligente do clássico 'tree' com configs coloridas/alias"
  ["trippy"]="🌐 Traceroute/Ping hiper gráfico focados c/ relatórios detalhados ping/loss net"
  ["trivy"]="🛡️ Verificador ultra rápido e abrangente focado em vulnerabilidade de imagens OS"
  ["trufflehog"]="🔑 Ferramenta de auditoria profunda pra achar keys e senhas comitadas na repo net"
  ["trzsz"]="📤 CLI de up/down com barra progresso nativa focado pra usar c/ tmux iTerm2 e ssh"
  ["tt"]="⌨️ Testador TUI estético de digitação focado no estilo minimalista do shell custom"
  ["ttyd"]="🌐 Proxy mágico C++ focado em transmitir teu emulador de term TUI pra URL browser"
  ["ttyper"]="⌨️ Aplicativo focado p teste digitação nativa focado rust com layouts de teclado diff"
  ["turbo"]="⚡ Ferramenta e build system bundler vercel hiper rápido focado pra monorepos JavaScript/TypeScript"
  ["turso"]="🗄️ CLI focado no gerenciamento TUI pra DB distribuidos baseados na edge no SQLite"
  ["typos"]="✏️ Linter corretor mágico focado veloz que pega typpos em grandes repozitórios C/Git"
  ["typos-cli"]="✏️ Wrapper TUI focado utilitário de auto fix grammar nativo pra Typos Rust repo"
  ["typst"]="📜 Sistema tipográfico de marcação compilada hiper rápido focado em bater o LaTeX"
  ["ugit"]="⏪ CLI TUI desfaz a ultima burrada comitata via alias inteligente revertendo commits"
  ["ugrep"]="🔍 Grep turbinado C++ com grep iterativo interativo q varre multiarquivos mega fast"
  ["usql"]="🗄️ Cliente universal DB em terminal pra postgress/ myqsl/ sqlite/ cassandra e dezenas+"
  ["uv"]="🐍 Gerenciador nativo Python/Pip rust based q instala pacotes em milisegundos via cargo"
  ["vault"]="🔐 Secrets manager da Hashi corp pra orquestrar acesso config PKI remoto"
  ["vcluster"]="☸️ Criador TUI focado em provisionar virtual kubernetes cluster dentro da ns do admin"
  ["vegeta"]="🔫 Atacador super veloz golang pra load tests estáticos de HTTP focado c/ reports csv"
  ["vercel"]="☁️ Ferramenta cloud TUI pra deploy e link na varcel s/ necessidade de abrir portal web"
  ["vhs"]="🎥 Gravador scriptável estético focado Charm terminal sessions pra GIF via chrome deamon"
  ["viddy"]="👀 Watch de loops custom em golang focado modern que mantem color bash e history nativo"
  ["visidata"]="📊 Multitool focado terminal interativo pra visualizar explorar processar data sheet CSV JS"
  ["viu"]="🖼️ Renderiza a imagem braba ali msm em TUI direto no cell do terminal renderizando pixel block"
  ["vivid"]="🌈 Configura dezenas variaveis $LS_COLORS focadas coloridas com defaults incríveis CLI"
  ["vscode"]="💻 Code editor da Microsoft"
  ["walk"]="🚶 Navegador CLI super leve e simples com atalhos Vim pra rodar cmds inline dir focado"
  ["warp"]="🚀 Terminal acelerado GPU focado AI auto-completar com interface ide-like revolucionária"
  ["watchexec"]="🔁 Executor que vigia pastas focadas e roda cmds na mudanca de files ex reload test watcher"
  ["waypoint"]="☁️ Empacota roda e faz deploy em multi ambientes focado Hashicorp"
  ["websocat"]="🌐 Canivete suiço focado rust tool netcat para WebSockets via TUI c/ debug proxy client/serv"
  ["wezterm"]="🪟 Emulador terminal rust focado em ser o melhor config com tabs/ gpu acelerado via config Lua"
  ["wiki-tui"]="📚 Renderizador focado pra buscar wiki pages direto da wikipedia usando TUI incrivelmente rápido"
  ["windsurf"]="🌊 Ferramenta AI IDE proxy proxy local"
  ["wtf"]="📊 Dashboard purista go focado personalizável que pega multiplas info widgets systema cli dev"
  ["wtfutil"]="📊 Alias do dashboard pessoal pra configs TUI (wtfutil)"
  ["wthrr"]="🌤️ Previsao clima purista focado terminal super charmoso"
  ["wthrr-the-weathercrab"]="🌤️ Previsao meteriológica alias extenso TUI rust"
  ["wuzz"]="🌐 Cliente focado terminal interativo purista pra depurar HTTP requests customizavel em TUI go"
  ["xc"]="🏃 Executador de rotinas puristas focado em ler de markdown em readme super prático pra task go"
  ["xcp"]="📋 Clonador rust utilitário de copia rápida 'cp' paralela inteligente q exibe progress bars TUI dir"
  ["xh"]="🌐 HTTP/API purista veloz em rust amigavel e cURL replacement pro request http com defaults bons"
  ["xplr"]="📂 File manager TUI purista focado TUI veloz em rust q foca no hacker hackeavel e lua configs"
  ["xsv"]="📊 Fatiador analisador indexador rust purista pra destrinchar csv colossais em ms c/ filters/join"
  ["yamlfmt"]="🧹 Formatador CLI go linter q conserta espaçamento chato e tab errors padronizando em .yaml files"
  ["yazi"]="📂 O melhor CLI file browser terminal focado em hyper perf usando assincrono em rust image render"
  ["yq"]="🔍 O classíco jq so que pra ler arquivos yml json xml toml properties em golang TUI terminal query"
  ["yt-dlp"]="🎥 O utilitário pika focado em forkar youtube-dl pra burlar limite banda baixar mp4 mp3 de sites"
  ["zed"]="📝 O sublime text killer editor colaborativo rust purista ultra responsivo renderizado via gpu max fps"
  ["zellij"]="🪟 Multiplexador tipo tmux mas incrivel com ui built-in focada rust out-of-the-box super hackeavel"
  ["zen-browser"]="🌐 O firefox fork rust focado ultra privacy com customizações de tela dividida estilo arc purista"
  ["zenith"]="📊 O monitor rust TUI purista tipo htop q desenha zoom charts graficos históricos de rede discos CPU"
  ["zig"]="⚡ A linguagem de sistemas modernosa que quer matar C e ja vem com um toolchain compativel C/C++ insano"
  ["zizmor"]="🛡️ Verificador estático de configs rust pra testar e rodar linter em GitHub actions ci configs purista"
  ["zoxide"]="⚡ O substituto veloz magico p CD rust purista que memoriza pasta que tu acessou pra jumps inteligentes"
  ["zrok"]="🚇 Tunel seguro open-source p2p Ziti focado ngrok alternative utilitário pra expor localhost pro mundo"
  ["zsh"]="🐚 Shell purista pra macOS e Linux super plugavel veloz focada autocompletion e defaults expansivos"
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
    --padding "1 4" --margin "1 0" --align center  \
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
    --align center --margin "3 2" --padding "4 6" \
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
    --border double --align center  --margin "1 2" --padding "2 3" \
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
