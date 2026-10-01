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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce fastfetch kew gaze dnote lolcat)
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
["act"]="🚀 act (App/Tool)"
["actionlint"]="🚀 actionlint (App/Tool)"
["age"]="🚀 age (App/Tool)"
["aichat"]="🚀 aichat (App/Tool)"
["aider"]="🚀 aider (App/Tool)"
["aider-chat"]="🚀 aider-chat (App/Tool)"
["amber"]="🚀 amber (App/Tool)"
["android"]="🚀 android (App/Tool)"
["aqua"]="🚀 aqua (App/Tool)"
["argc"]="🚀 argc (App/Tool)"
["argocd"]="🚀 argocd (App/Tool)"
["ast-grep"]="🚀 ast-grep (App/Tool)"
["atac"]="🚀 atac (App/Tool)"
["atlas"]="🚀 atlas (App/Tool)"
["atuin"]="🚀 atuin (App/Tool)"
["awscli"]="🚀 awscli (App/Tool)"
["bacon"]="🚀 bacon (App/Tool)"
["bandwhich"]="🚀 bandwhich (App/Tool)"
["bat"]="🚀 bat (App/Tool)"
["bat-extras"]="🚀 bat-extras (App/Tool)"
["binsider"]="🚀 binsider (App/Tool)"
["biome"]="🚀 biome (App/Tool)"
["bito"]="🚀 bito (App/Tool)"
["bluetuith"]="🚀 bluetuith (App/Tool)"
["bore-cli"]="🚀 bore-cli (App/Tool)"
["bottom"]="🚀 bottom (App/Tool)"
["boundary"]="🚀 boundary (App/Tool)"
["brave"]="🚀 brave (App/Tool)"
["broot"]="🚀 broot (App/Tool)"
["bruno"]="🚀 bruno (App/Tool)"
["bruno-cli"]="🚀 bruno-cli (App/Tool)"
["btop"]="🚀 btop (App/Tool)"
["bun"]="🚀 bun (App/Tool)"
["bw"]="🚀 bw (App/Tool)"
["carapace"]="🚀 carapace (App/Tool)"
["cbonsai"]="🚀 cbonsai (App/Tool)"
["chafa"]="🚀 chafa (App/Tool)"
["charm"]="🚀 charm (App/Tool)"
["chatbox"]="🚀 chatbox (App/Tool)"
["chatgpt-cli"]="🚀 chatgpt-cli (App/Tool)"
["cheat"]="🚀 cheat (App/Tool)"
["checkov"]="🚀 checkov (App/Tool)"
["choose"]="🚀 choose (App/Tool)"
["circumflex"]="🚀 circumflex (App/Tool)"
["claude-code"]="🚀 claude-code (App/Tool)"
["cli-tools"]="🚀 cli-tools (Modern CLI Tools/Dependencies)"
["cline"]="🚀 cline (App/Tool)"
["cloudflared"]="🚀 cloudflared (App/Tool)"
["cmatrix"]="🚀 cmatrix (App/Tool)"
["cocogitto"]="🚀 cocogitto (App/Tool)"
["code2prompt"]="🚀 code2prompt (App/Tool)"
["cointop"]="🚀 cointop (App/Tool)"
["consul"]="🚀 consul (App/Tool)"
["cpufetch"]="🚀 cpufetch (App/Tool)"
["crane"]="🚀 crane (App/Tool)"
["croc"]="🚀 croc (App/Tool)"
["csvlens"]="🚀 csvlens (App/Tool)"
["ctop"]="🚀 ctop (App/Tool)"
["curlie"]="🚀 curlie (App/Tool)"
["cursor"]="🚀 cursor (App/Tool)"
["czg"]="🚀 czg (App/Tool)"
["d2"]="🚀 d2 (App/Tool)"
["dagger"]="🚀 dagger (App/Tool)"
["dapr"]="🚀 dapr (App/Tool)"
["dasel"]="🚀 dasel (App/Tool)"
["daytona"]="🚀 daytona (App/Tool)"
["dbeaver"]="🚀 dbeaver (App/Tool)"
["dbmate"]="🚀 dbmate (App/Tool)"
["delta"]="🚀 delta (App/Tool)"
["deno"]="🚀 deno (App/Tool)"
["devbox"]="🚀 devbox (App/Tool)"
["devenv"]="🚀 devenv (App/Tool)"
["devpod"]="🚀 devpod (App/Tool)"
["devspace"]="🚀 devspace (App/Tool)"
["devtoy"]="🚀 devtoy (App/Tool)"
["difftastic"]="🚀 difftastic (App/Tool)"
["direnv"]="🚀 direnv (App/Tool)"
["discord"]="🚀 discord (App/Tool)"
["diskonaut"]="🚀 diskonaut (App/Tool)"
["distrobox"]="🚀 distrobox (App/Tool)"
["dive"]="🚀 dive (App/Tool)"
["dnote"]="🚀 dnote (App/Tool)"
["docker"]="🚀 docker (App/Tool)"
["doggo"]="🚀 doggo (App/Tool)"
["dolt"]="🚀 dolt (App/Tool)"
["doppler"]="🚀 doppler (App/Tool)"
["dotenv-linter"]="🚀 dotenv-linter (App/Tool)"
["dotenvx"]="🚀 dotenvx (App/Tool)"
["dprint"]="🚀 dprint (App/Tool)"
["dsq"]="🚀 dsq (App/Tool)"
["dua"]="🚀 dua (App/Tool)"
["dua-cli"]="🚀 dua-cli (App/Tool)"
["duckdb"]="🚀 duckdb (App/Tool)"
["duf"]="🚀 duf (App/Tool)"
["dufs"]="🚀 dufs (App/Tool)"
["dura"]="🚀 dura (App/Tool)"
["dust"]="🚀 dust (App/Tool)"
["dysk"]="🚀 dysk (App/Tool)"
["earthly"]="🚀 earthly (App/Tool)"
["eget"]="🚀 eget (App/Tool)"
["elixir"]="🚀 elixir (App/Tool)"
["erdtree"]="🚀 erdtree (App/Tool)"
["evans"]="🚀 evans (App/Tool)"
["eza"]="🚀 eza (App/Tool)"
["fabric"]="🚀 fabric (App/Tool)"
["fastfetch"]="🚀 fastfetch (App/Tool)"
["fd-find"]="🚀 fd-find (App/Tool)"
["fend"]="🚀 fend (App/Tool)"
["ffuf"]="🚀 ffuf (App/Tool)"
["firefox"]="🚀 firefox (App/Tool)"
["flox"]="🚀 flox (App/Tool)"
["flyctl"]="🚀 flyctl (App/Tool)"
["fnm"]="🚀 fnm (App/Tool)"
["fq"]="🚀 fq (App/Tool)"
["freeze"]="🚀 freeze (App/Tool)"
["fx"]="🚀 fx (App/Tool)"
["fzf"]="🚀 fzf (App/Tool)"
["gaze"]="🚀 gaze (App/Tool)"
["gcloud"]="🚀 gcloud (App/Tool)"
["gdu"]="🚀 gdu (App/Tool)"
["genact"]="🚀 genact (App/Tool)"
["gh"]="🚀 gh (App/Tool)"
["gh-dash"]="🚀 gh-dash (App/Tool)"
["ghostty"]="🚀 ghostty (App/Tool)"
["ghq"]="🚀 ghq (App/Tool)"
["git-absorb"]="🚀 git-absorb (App/Tool)"
["git-cliff"]="🚀 git-cliff (App/Tool)"
["git-filter-repo"]="🚀 git-filter-repo (App/Tool)"
["git-next"]="🚀 git-next (App/Tool)"
["git-sim"]="🚀 git-sim (App/Tool)"
["git-town"]="🚀 git-town (App/Tool)"
["gitingest"]="🚀 gitingest (App/Tool)"
["gitleaks"]="🚀 gitleaks (App/Tool)"
["gitui"]="🚀 gitui (App/Tool)"
["glab"]="🚀 glab (App/Tool)"
["glances"]="🚀 glances (App/Tool)"
["gleam"]="🚀 gleam (App/Tool)"
["glow"]="🚀 glow (App/Tool)"
["gobang"]="🚀 gobang (App/Tool)"
["gojq"]="🚀 gojq (App/Tool)"
["gorilla-cli"]="🚀 gorilla-cli (App/Tool)"
["gping"]="🚀 gping (App/Tool)"
["gptme"]="🚀 gptme (App/Tool)"
["grex"]="🚀 grex (App/Tool)"
["gron"]="🚀 gron (App/Tool)"
["grpcurl"]="🚀 grpcurl (App/Tool)"
["grype"]="🚀 grype (App/Tool)"
["gtt"]="🚀 gtt (App/Tool)"
["gum"]="🚀 gum (App/Tool)"
["hadolint"]="🚀 hadolint (App/Tool)"
["harlequin"]="🚀 harlequin (App/Tool)"
["hck"]="🚀 hck (App/Tool)"
["helix"]="🚀 helix (App/Tool)"
["helm"]="🚀 helm (App/Tool)"
["heroku"]="🚀 heroku (App/Tool)"
["hexyl"]="🚀 hexyl (App/Tool)"
["howdoi"]="🚀 howdoi (App/Tool)"
["htmlq"]="🚀 htmlq (App/Tool)"
["htop"]="🚀 htop (App/Tool)"
["httpie"]="🚀 httpie (App/Tool)"
["httpstat"]="🚀 httpstat (App/Tool)"
["httpx"]="🚀 httpx (App/Tool)"
["hurl"]="🚀 hurl (App/Tool)"
["hwatch"]="🚀 hwatch (App/Tool)"
["hyperfine"]="🚀 hyperfine (App/Tool)"
["igrep"]="🚀 igrep (App/Tool)"
["infisical"]="🚀 infisical (App/Tool)"
["infracost"]="🚀 infracost (App/Tool)"
["inlyne"]="🚀 inlyne (App/Tool)"
["inshellisense"]="🚀 inshellisense (App/Tool)"
["jan"]="🚀 jan (App/Tool)"
["jaq"]="🚀 jaq (App/Tool)"
["jc"]="🚀 jc (App/Tool)"
["jira-cli"]="🚀 jira-cli (App/Tool)"
["jj"]="🚀 jj (App/Tool)"
["jless"]="🚀 jless (App/Tool)"
["jnv"]="🚀 jnv (App/Tool)"
["jo"]="🚀 jo (App/Tool)"
["joshuto"]="🚀 joshuto (App/Tool)"
["jq"]="🚀 jq (App/Tool)"
["jql"]="🚀 jql (App/Tool)"
["jqp"]="🚀 jqp (App/Tool)"
["jujutsu"]="🚀 jujutsu (App/Tool)"
["just"]="🚀 just (App/Tool)"
["k3d"]="🚀 k3d (App/Tool)"
["k3s"]="🚀 k3s (App/Tool)"
["k6"]="🚀 k6 (App/Tool)"
["k8sgpt"]="🚀 k8sgpt (App/Tool)"
["k9s-cli"]="🚀 k9s-cli (App/Tool)"
["kakoune"]="🚀 kakoune (App/Tool)"
["kalker"]="🚀 kalker (App/Tool)"
["kaskade"]="🚀 kaskade (App/Tool)"
["kcl"]="🚀 kcl (App/Tool)"
["kdash"]="🚀 kdash (App/Tool)"
["kew"]="🚀 kew (App/Tool)"
["kind"]="🚀 kind (App/Tool)"
["klog"]="🚀 klog (App/Tool)"
["kmon"]="🚀 kmon (App/Tool)"
["ko"]="🚀 ko (App/Tool)"
["kondo"]="🚀 kondo (App/Tool)"
["krew"]="🚀 krew (App/Tool)"
["kubecolor"]="🚀 kubecolor (App/Tool)"
["kubectl"]="🚀 kubectl (App/Tool)"
["kubectx"]="🚀 kubectx (App/Tool)"
["kubens"]="🚀 kubens (App/Tool)"
["kubent"]="🚀 kubent (App/Tool)"
["kustomize"]="🚀 kustomize (App/Tool)"
["lapce"]="🚀 lapce (App/Tool)"
["lazydocker"]="🚀 lazydocker (App/Tool)"
["lazygit"]="🚀 lazygit (App/Tool)"
["lazygit-tui"]="🚀 lazygit-tui (App/Tool)"
["lazynpm"]="🚀 lazynpm (App/Tool)"
["lazysql"]="🚀 lazysql (App/Tool)"
["lazyvim"]="🚀 lazyvim (App/Tool)"
["lefthook"]="🚀 lefthook (App/Tool)"
["lens"]="🚀 lens (App/Tool)"
["lf"]="🚀 lf (App/Tool)"
["litecli"]="🚀 litecli (App/Tool)"
["llm"]="🚀 llm (App/Tool)"
["lmstudio"]="🚀 lmstudio (App/Tool)"
["lnav"]="🚀 lnav (App/Tool)"
["lolcat"]="🚀 lolcat (App/Tool)"
["lsd"]="🚀 lsd (App/Tool)"
["lychee"]="🚀 lychee (App/Tool)"
["macchina"]="🚀 macchina (App/Tool)"
["mani"]="🚀 mani (App/Tool)"
["marimo"]="🚀 marimo (App/Tool)"
["mcfly"]="🚀 mcfly (App/Tool)"
["mdcat"]="🚀 mdcat (App/Tool)"
["melt"]="🚀 melt (App/Tool)"
["micro"]="🚀 micro (App/Tool)"
["miller"]="🚀 miller (App/Tool)"
["miniserve"]="🚀 miniserve (App/Tool)"
["mise"]="🚀 mise (App/Tool)"
["mkcert"]="🚀 mkcert (App/Tool)"
["mlr"]="🚀 mlr (App/Tool)"
["moar"]="🚀 moar (App/Tool)"
["mods"]="🚀 mods (App/Tool)"
["monolith"]="🚀 monolith (App/Tool)"
["moon"]="🚀 moon (App/Tool)"
["mprocs"]="🚀 mprocs (App/Tool)"
["mycli"]="🚀 mycli (App/Tool)"
["mysql"]="🚀 mysql (App/Tool)"
["nap"]="🚀 nap (App/Tool)"
["navi"]="🚀 navi (App/Tool)"
["ncdu"]="🚀 ncdu (App/Tool)"
["ncspot"]="🚀 ncspot (App/Tool)"
["neofetch-alt"]="🚀 neofetch-alt (App/Tool)"
["neovim"]="🚀 neovim (App/Tool)"
["netlify"]="🚀 netlify (App/Tool)"
["newsboat"]="🚀 newsboat (App/Tool)"
["ngrok"]="🚀 ngrok (App/Tool)"
["nix"]="🚀 nix (App/Tool)"
["nnn"]="🚀 nnn (App/Tool)"
["nomad"]="🚀 nomad (App/Tool)"
["nuclei"]="🚀 nuclei (App/Tool)"
["numbat"]="🚀 numbat (App/Tool)"
["nushell"]="🚀 nushell (App/Tool)"
["obsidian"]="🚀 obsidian (App/Tool)"
["oh-my-posh"]="🚀 oh-my-posh (App/Tool)"
["oha"]="🚀 oha (App/Tool)"
["ollama"]="🚀 ollama (App/Tool)"
["onefetch"]="🚀 onefetch (App/Tool)"
["open-interpreter"]="🚀 open-interpreter (App/Tool)"
["opentofu"]="🚀 opentofu (App/Tool)"
["ouch"]="🚀 ouch (App/Tool)"
["oxker"]="🚀 oxker (App/Tool)"
["oxlint"]="🚀 oxlint (App/Tool)"
["packer"]="🚀 packer (App/Tool)"
["pastel"]="🚀 pastel (App/Tool)"
["peco"]="🚀 peco (App/Tool)"
["pgcli"]="🚀 pgcli (App/Tool)"
["pipes-rs"]="🚀 pipes-rs (App/Tool)"
["pipes-sh"]="🚀 pipes-sh (App/Tool)"
["pixi"]="🚀 pixi (App/Tool)"
["pkgx"]="🚀 pkgx (App/Tool)"
["plandex"]="🚀 plandex (App/Tool)"
["pls"]="🚀 pls (App/Tool)"
["pnpm"]="🚀 pnpm (App/Tool)"
["podman"]="🚀 podman (App/Tool)"
["poetry"]="🚀 poetry (App/Tool)"
["pokeget"]="🚀 pokeget (App/Tool)"
["pomsky"]="🚀 pomsky (App/Tool)"
["popeye"]="🚀 popeye (App/Tool)"
["porsmo"]="🚀 porsmo (App/Tool)"
["posting"]="🚀 posting (App/Tool)"
["presenterm"]="🚀 presenterm (App/Tool)"
["procs"]="🚀 procs (App/Tool)"
["proto"]="🚀 proto (App/Tool)"
["pueue"]="🚀 pueue (App/Tool)"
["pulumi"]="🚀 pulumi (App/Tool)"
["px"]="🚀 px (App/Tool)"
["qsv"]="🚀 qsv (App/Tool)"
["repomix"]="🚀 repomix (App/Tool)"
["rio"]="🚀 rio (App/Tool)"
["rip"]="🚀 rip (App/Tool)"
["ripgrep"]="🚀 ripgrep (App/Tool)"
["ripgrep_all"]="🚀 ripgrep_all (App/Tool)"
["rnr"]="🚀 rnr (App/Tool)"
["rs-cmatrix"]="🚀 rs-cmatrix (App/Tool)"
["ruff"]="🚀 ruff (App/Tool)"
["ruplacer"]="🚀 ruplacer (App/Tool)"
["rustscan"]="🚀 rustscan (App/Tool)"
["rye"]="🚀 rye (App/Tool)"
["sad"]="🚀 sad (App/Tool)"
["scc"]="🚀 scc (App/Tool)"
["sd"]="🚀 sd (App/Tool)"
["serie"]="🚀 serie (App/Tool)"
["serpl"]="🚀 serpl (App/Tool)"
["sesh"]="🚀 sesh (App/Tool)"
["shell-gpt"]="🚀 shell-gpt (App/Tool)"
["shellcheck"]="🚀 shellcheck (App/Tool)"
["shfmt"]="🚀 shfmt (App/Tool)"
["silicon"]="🚀 silicon (App/Tool)"
["skate"]="🚀 skate (App/Tool)"
["skim"]="🚀 skim (App/Tool)"
["slack"]="🚀 slack (App/Tool)"
["slides"]="🚀 slides (App/Tool)"
["slumber"]="🚀 slumber (App/Tool)"
["sniffnet"]="🚀 sniffnet (App/Tool)"
["so"]="🚀 so (App/Tool)"
["sops"]="🚀 sops (App/Tool)"
["spacer"]="🚀 spacer (App/Tool)"
["spt"]="🚀 spt (App/Tool)"
["sqlc"]="🚀 sqlc (App/Tool)"
["starship"]="🚀 starship (App/Tool)"
["steampipe"]="🚀 steampipe (App/Tool)"
["stern"]="🚀 stern (App/Tool)"
["stripe"]="🚀 stripe (App/Tool)"
["supabase"]="🚀 supabase (App/Tool)"
["superfile"]="🚀 superfile (App/Tool)"
["syft"]="🚀 syft (App/Tool)"
["systemctl-tui"]="🚀 systemctl-tui (App/Tool)"
["systeroid"]="🚀 systeroid (App/Tool)"
["sysz"]="🚀 sysz (App/Tool)"
["t-rec"]="🚀 t-rec (App/Tool)"
["tailspin"]="🚀 tailspin (App/Tool)"
["taplo"]="🚀 taplo (App/Tool)"
["task"]="🚀 task (App/Tool)"
["taskwarrior-tui"]="🚀 taskwarrior-tui (App/Tool)"
["tealdeer"]="🚀 tealdeer (App/Tool)"
["television"]="🚀 television (App/Tool)"
["tenki"]="🚀 tenki (App/Tool)"
["tenv"]="🚀 tenv (App/Tool)"
["tere"]="🚀 tere (App/Tool)"
["termdbms"]="🚀 termdbms (App/Tool)"
["termscp"]="🚀 termscp (App/Tool)"
["termshark"]="🚀 termshark (App/Tool)"
["termtyper"]="🚀 termtyper (App/Tool)"
["terragrunt"]="🚀 terragrunt (App/Tool)"
["tflint"]="🚀 tflint (App/Tool)"
["tfsec"]="🚀 tfsec (App/Tool)"
["tgpt"]="🚀 tgpt (App/Tool)"
["thefuck"]="🚀 thefuck (App/Tool)"
["tickrs"]="🚀 tickrs (App/Tool)"
["tig"]="🚀 tig (App/Tool)"
["tilt"]="🚀 tilt (App/Tool)"
["tin-summer"]="🚀 tin-summer (App/Tool)"
["tldr"]="🚀 tldr (App/Tool)"
["tlrc"]="🚀 tlrc (App/Tool)"
["tmate"]="🚀 tmate (App/Tool)"
["tmux"]="🚀 tmux (App/Tool)"
["tokei"]="🚀 tokei (App/Tool)"
["topgrade"]="🚀 topgrade (App/Tool)"
["trash-cli"]="🚀 trash-cli (App/Tool)"
["tre"]="🚀 tre (App/Tool)"
["trippy"]="🚀 trippy (App/Tool)"
["trivy"]="🚀 trivy (App/Tool)"
["trufflehog"]="🚀 trufflehog (App/Tool)"
["trzsz"]="🚀 trzsz (App/Tool)"
["tt"]="🚀 tt (App/Tool)"
["ttyd"]="🚀 ttyd (App/Tool)"
["ttyper"]="🚀 ttyper (App/Tool)"
["turso"]="🚀 turso (App/Tool)"
["typos"]="🚀 typos (App/Tool)"
["typos-cli"]="🚀 typos-cli (App/Tool)"
["typst"]="🚀 typst (App/Tool)"
["ugit"]="🚀 ugit (App/Tool)"
["ugrep"]="🚀 ugrep (App/Tool)"
["usql"]="🚀 usql (App/Tool)"
["uv"]="🚀 uv (App/Tool)"
["vault"]="🚀 vault (App/Tool)"
["vcluster"]="🚀 vcluster (App/Tool)"
["vegeta"]="🚀 vegeta (App/Tool)"
["vercel"]="🚀 vercel (App/Tool)"
["vhs"]="🚀 vhs (App/Tool)"
["viddy"]="🚀 viddy (App/Tool)"
["visidata"]="🚀 visidata (App/Tool)"
["viu"]="🚀 viu (App/Tool)"
["vivid"]="🚀 vivid (App/Tool)"
["vscode"]="🚀 vscode (App/Tool)"
["walk"]="🚀 walk (App/Tool)"
["warp"]="🚀 warp (App/Tool)"
["watchexec"]="🚀 watchexec (App/Tool)"
["waypoint"]="🚀 waypoint (App/Tool)"
["websocat"]="🚀 websocat (App/Tool)"
["wezterm"]="🚀 wezterm (App/Tool)"
["wiki-tui"]="🚀 wiki-tui (App/Tool)"
["windsurf"]="🚀 windsurf (App/Tool)"
["wtf"]="🚀 wtf (App/Tool)"
["wtfutil"]="🚀 wtfutil (App/Tool)"
["wthrr"]="🚀 wthrr (App/Tool)"
["wthrr-the-weathercrab"]="🚀 wthrr-the-weathercrab (App/Tool)"
["wuzz"]="🚀 wuzz (App/Tool)"
["xc"]="🚀 xc (App/Tool)"
["xcp"]="🚀 xcp (App/Tool)"
["xh"]="🚀 xh (App/Tool)"
["xplr"]="🚀 xplr (App/Tool)"
["xsv"]="🚀 xsv (App/Tool)"
["yamlfmt"]="🚀 yamlfmt (App/Tool)"
["yazi"]="🚀 yazi (App/Tool)"
["yq"]="🚀 yq (App/Tool)"
["yt-dlp"]="🚀 yt-dlp (App/Tool)"
["zed"]="🚀 zed (App/Tool)"
["zellij"]="🚀 zellij (App/Tool)"
["zen-browser"]="🚀 zen-browser (App/Tool)"
["zenith"]="🚀 zenith (App/Tool)"
["zig"]="🚀 zig (App/Tool)"
["zizmor"]="🚀 zizmor (App/Tool)"
["zoxide"]="🚀 zoxide (App/Tool)"
["zrok"]="🚀 zrok (App/Tool)"
["zsh"]="🚀 zsh (App/Tool)"
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
