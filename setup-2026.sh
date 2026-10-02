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
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun act actionlint age aichat aider amber android ast-grep atac atlas atuin bacon bandwhich bat-extras binsider biome bluetuith bore-cli bottom brave broot bruno carapace cbonsai chafa charm chatbox chatgpt-cli cheat checkov choose circumflex claude-code cline cloudflared cocogitto code2prompt cointop cpufetch cmatrix crane croc csvlens ctop curlie cursor czg d2 dagger dasel daytona dbeaver dbmate delta deno devbox devenv devpod difftastic direnv discord diskonaut distrobox dive docker doggo dolt dotenv-linter dotenvx dprint dsq dua dua-cli duckdb duf dufs dura dust dysk earthly eget erdtree evans fabric neofetch-alt fend firefox flox flyctl fnm fq freeze fx gcloud gdu genact gh gh-dash ghostty ghq git-absorb git-cliff git-filter-repo git-sim git-town gitingest gitleaks gitui glab glances glow gobang gojq gping grex gron grpcurl grype gtt gum hadolint harlequin hck helix helm hexyl howdoi htop htmlq httpie httpstat httpx hurl hwatch hyperfine igrep infracost inlyne inshellisense jan jaq jc jira-cli jj jless jnv jo joshuto jq jql jqp jujutsu just k3d k6 k8sgpt k9s-cli kalker kdash kind klog kmon ko kondo krew kubecolor kubectl kubectx kustomize lazydocker lazygit-tui lazynpm lazysql lefthook lf llm lmstudio lnav lsd lychee macchina mani mcfly mdcat melt miller miniserve mise mkcert moar mods monolith moon mprocs mysql nap navi ncspot neovim newsboat ngrok nuclei numbat nushell obsidian oha ollama onefetch open-interpreter opentofu ouch oxker oxlint pastel peco pipes-rs pipes-sh pkgx plandex poetry pnpm podman pokeget pomsky popeye porsmo posting presenterm procs pueue px qsv repomix rip rnr rs-cmatrix ruff ruplacer rustscan rye sad scc sd serie serpl sesh shell-gpt shellcheck shfmt silicon skate skim slack slides slumber sniffnet so sops spacer spt sqlc steampipe stern supabase superfile syft systemctl-tui systeroid sysz t-rec tailspin taplo task taskwarrior-tui tealdeer television tenki tenv termdbms termscp termshark termtyper tfsec tgpt thefuck tickrs tilt tin-summer tldr tlrc tmux tokei topgrade trash-cli tre trippy trivy trufflehog trzsz tt ttyper turso typos typst ugit ugrep usql uv vault vcluster vegeta vhs viddy visidata viu vivid vscode walk warp watchexec websocat wezterm wiki-tui windsurf wtfutil wthrr wuzz xc xcp xh xplr xsv yamlfmt yazi yq yt-dlp zed zellij zen-browser zenith zizmor zrok ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer dapr aider-chat typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next pgcli mycli litecli tere kubent lazyvim oh-my-posh gptme micro nnn tig ncdu kakoune ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce fastfetch kew gaze dnote lolcat common)
    ;;
  ai-dev)
    DEFAULT_MODULES=(nix zig gleam elixir eza bat zoxide fzf ripgrep fd-find btop cli-tools zsh starship bun cursor zed warp ghostty lazygit-tui lazydocker zellij yazi neovim docker uv ollama claude-code zen-browser lmstudio bruno wezterm dbeaver windsurf k9s-cli posting superfile aider plandex open-interpreter duckdb harlequin neofetch-alt lazysql gitingest repomix shell-gpt atac dsq t-rec cbonsai pipes-sh mprocs mise atuin devbox dagger deno biome ruff broot doggo tokei jless oha curlie procs pueue aichat fabric k8sgpt tgpt jo k6 television code2prompt jan chatbox inshellisense podman devpod daytona mods llm cline glow slumber lazynpm gitui kdash nap sd choose gobang bottom macchina xplr circumflex lsd aider-chat trippy onefetch grex bandwhich amber tailspin erdtree dua oxlint difftastic topgrade pastel numbat dufs jj sesh carapace moar vhs gitleaks xc gdu trash-cli yt-dlp glances d2 pnpm fnm gping kondo presenterm hexyl csvlens pomsky bacon wiki-tui ast-grep dive gron viddy wtfutil cointop dasel dust navi delta websocat ouch zenith git-cliff typos fend joshuto sniffnet termscp wthrr miniserve zizmor inlyne so xcp taplo tlrc typst xsv gh act task croc dbmate ripgrep_all kubens doppler infisical stripe awscli vercel pulumi terragrunt tflint ttyd argc argocd k3s vault bw netlify heroku consul nomad packer typos-cli wthrr-the-weathercrab bruno-cli wtf mlr pls devtoy git-next gptme ffuf tmate kaskade aqua kcl devspace lazygit lens marimo bito gorilla-cli boundary waypoint pixi proto rio lapce tmux htop cmatrix vivid hadolint ugit pgcli mycli litecli tere kubent lazyvim oh-my-posh micro nnn tig ncdu kakoune hck termshark kmon poetry fastfetch serie eget skate checkov freeze binsider distrobox tenv mkcert dprint steampipe dua-cli ttyper rs-cmatrix systeroid lefthook vscode klog grpcurl dotenv-linter just obsidian flyctl turso kubecolor ko vcluster visidata syft common stern popeye qsv cheat silicon age peco cocogitto termtyper android git-absorb ngrok charm jira-cli bat-extras genact cpufetch lnav ghq pokeget ctop git-town hurl actionlint ugrep mdcat jc nuclei wuzz httpstat gojq lychee kalker httpie sqlc htmlq sysz chafa fq px melt kubectx termdbms dolt dapr xh newsboat jujutsu thefuck rnr monolith serpl fx shellcheck tickrs mysql cloudflared scc evans watchexec direnv dura kustomize czg git-filter-repo kubectl hyperfine bore-cli pkgx glab helix gh-dash httpx diskonaut porsmo trufflehog usql tenki sops pipes-rs trivy shfmt infracost flox duf kind dysk howdoi vegeta skim gum firefox k3d tin-summer krew yamlfmt jq ncspot oxker moon nushell taskwarrior-tui discord rip dnote yq hwatch tilt slack mani chatgpt-cli gaze brave jnv dotenvx devenv tfsec tealdeer grype tre jaq slides systemctl-tui sad kew rustscan spacer miller bluetuith viu atlas gtt trzsz ruplacer crane lolcat gcloud jqp earthly jql opentofu igrep tldr lf tt mcfly rye zrok helm supabase spt git-sim walk)
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
  ["act"]="🚀 act"
  ["actionlint"]="🚀 actionlint"
  ["age"]="🚀 age"
  ["aichat"]="🚀 aichat"
  ["aider"]="🚀 aider"
  ["aider-chat"]="🚀 aider-chat"
  ["amber"]="🚀 amber"
  ["android"]="🚀 android"
  ["aqua"]="🚀 aqua"
  ["argc"]="🚀 argc"
  ["argocd"]="🚀 argocd"
  ["ast-grep"]="🚀 ast-grep"
  ["atac"]="🚀 atac"
  ["atlas"]="🚀 atlas"
  ["atuin"]="🚀 atuin"
  ["awscli"]="🚀 awscli"
  ["bacon"]="🚀 bacon"
  ["bandwhich"]="🚀 bandwhich"
  ["bat"]="🚀 bat"
  ["bat-extras"]="🚀 bat-extras"
  ["binsider"]="🚀 binsider"
  ["biome"]="🚀 biome"
  ["bito"]="🚀 bito"
  ["bluetuith"]="🚀 bluetuith"
  ["bore-cli"]="🚀 bore-cli"
  ["bottom"]="🚀 bottom"
  ["boundary"]="🚀 boundary"
  ["brave"]="🚀 brave"
  ["broot"]="🚀 broot"
  ["bruno"]="🚀 bruno"
  ["bruno-cli"]="🚀 bruno-cli"
  ["btop"]="🚀 btop"
  ["bun"]="🚀 bun"
  ["bw"]="🚀 bw"
  ["carapace"]="🚀 carapace"
  ["cbonsai"]="🚀 cbonsai"
  ["chafa"]="🚀 chafa"
  ["charm"]="🚀 charm"
  ["chatbox"]="🚀 chatbox"
  ["chatgpt-cli"]="🚀 chatgpt-cli"
  ["cheat"]="🚀 cheat"
  ["checkov"]="🚀 checkov"
  ["choose"]="🚀 choose"
  ["circumflex"]="🚀 circumflex"
  ["claude-code"]="🚀 claude-code"
  ["cli-tools"]="🚀 cli-tools"
  ["cline"]="🚀 cline"
  ["cloudflared"]="🚀 cloudflared"
  ["cmatrix"]="🚀 cmatrix"
  ["cocogitto"]="🚀 cocogitto"
  ["code2prompt"]="🚀 code2prompt"
  ["cointop"]="🚀 cointop"
  ["common"]="🚀 common"
  ["consul"]="🚀 consul"
  ["cpufetch"]="🚀 cpufetch"
  ["crane"]="🚀 crane"
  ["croc"]="🚀 croc"
  ["csvlens"]="🚀 csvlens"
  ["ctop"]="🚀 ctop"
  ["curlie"]="🚀 curlie"
  ["cursor"]="🚀 cursor"
  ["czg"]="🚀 czg"
  ["d2"]="🚀 d2"
  ["dagger"]="🚀 dagger"
  ["dapr"]="🚀 dapr"
  ["dasel"]="🚀 dasel"
  ["daytona"]="🚀 daytona"
  ["dbeaver"]="🚀 dbeaver"
  ["dbmate"]="🚀 dbmate"
  ["delta"]="🚀 delta"
  ["deno"]="🚀 deno"
  ["devbox"]="🚀 devbox"
  ["devenv"]="🚀 devenv"
  ["devpod"]="🚀 devpod"
  ["devspace"]="🚀 devspace"
  ["devtoy"]="🚀 devtoy"
  ["difftastic"]="🚀 difftastic"
  ["direnv"]="🚀 direnv"
  ["discord"]="🚀 discord"
  ["diskonaut"]="🚀 diskonaut"
  ["distrobox"]="🚀 distrobox"
  ["dive"]="🚀 dive"
  ["dnote"]="🚀 dnote"
  ["docker"]="🚀 docker"
  ["doggo"]="🚀 doggo"
  ["dolt"]="🚀 dolt"
  ["doppler"]="🚀 doppler"
  ["dotenv-linter"]="🚀 dotenv-linter"
  ["dotenvx"]="🚀 dotenvx"
  ["dprint"]="🚀 dprint"
  ["dsq"]="🚀 dsq"
  ["dua"]="🚀 dua"
  ["dua-cli"]="🚀 dua-cli"
  ["duckdb"]="🚀 duckdb"
  ["duf"]="🚀 duf"
  ["dufs"]="🚀 dufs"
  ["dura"]="🚀 dura"
  ["dust"]="🚀 dust"
  ["dysk"]="🚀 dysk"
  ["earthly"]="🚀 earthly"
  ["eget"]="🚀 eget"
  ["elixir"]="🚀 elixir"
  ["erdtree"]="🚀 erdtree"
  ["evans"]="🚀 evans"
  ["eza"]="🚀 eza"
  ["fabric"]="🚀 fabric"
  ["fastfetch"]="🚀 fastfetch"
  ["fd-find"]="🚀 fd-find"
  ["fend"]="🚀 fend"
  ["ffuf"]="🚀 ffuf"
  ["firefox"]="🚀 firefox"
  ["flox"]="🚀 flox"
  ["flyctl"]="🚀 flyctl"
  ["fnm"]="🚀 fnm"
  ["fq"]="🚀 fq"
  ["freeze"]="🚀 freeze"
  ["fx"]="🚀 fx"
  ["fzf"]="🚀 fzf"
  ["gaze"]="🚀 gaze"
  ["gcloud"]="🚀 gcloud"
  ["gdu"]="🚀 gdu"
  ["genact"]="🚀 genact"
  ["gh"]="🚀 gh"
  ["gh-dash"]="🚀 gh-dash"
  ["ghostty"]="🚀 ghostty"
  ["ghq"]="🚀 ghq"
  ["git-absorb"]="🚀 git-absorb"
  ["git-cliff"]="🚀 git-cliff"
  ["git-filter-repo"]="🚀 git-filter-repo"
  ["git-next"]="🚀 git-next"
  ["git-sim"]="🚀 git-sim"
  ["git-town"]="🚀 git-town"
  ["gitingest"]="🚀 gitingest"
  ["gitleaks"]="🚀 gitleaks"
  ["gitui"]="🚀 gitui"
  ["glab"]="🚀 glab"
  ["glances"]="🚀 glances"
  ["gleam"]="🚀 gleam"
  ["glow"]="🚀 glow"
  ["gobang"]="🚀 gobang"
  ["gojq"]="🚀 gojq"
  ["gorilla-cli"]="🚀 gorilla-cli"
  ["gping"]="🚀 gping"
  ["gptme"]="🚀 gptme"
  ["grex"]="🚀 grex"
  ["gron"]="🚀 gron"
  ["grpcurl"]="🚀 grpcurl"
  ["grype"]="🚀 grype"
  ["gtt"]="🚀 gtt"
  ["gum"]="🚀 gum"
  ["hadolint"]="🚀 hadolint"
  ["harlequin"]="🚀 harlequin"
  ["hck"]="🚀 hck"
  ["helix"]="🚀 helix"
  ["helm"]="🚀 helm"
  ["heroku"]="🚀 heroku"
  ["hexyl"]="🚀 hexyl"
  ["howdoi"]="🚀 howdoi"
  ["htmlq"]="🚀 htmlq"
  ["htop"]="🚀 htop"
  ["httpie"]="🚀 httpie"
  ["httpstat"]="🚀 httpstat"
  ["httpx"]="🚀 httpx"
  ["hurl"]="🚀 hurl"
  ["hwatch"]="🚀 hwatch"
  ["hyperfine"]="🚀 hyperfine"
  ["igrep"]="🚀 igrep"
  ["infisical"]="🚀 infisical"
  ["infracost"]="🚀 infracost"
  ["inlyne"]="🚀 inlyne"
  ["inshellisense"]="🚀 inshellisense"
  ["jan"]="🚀 jan"
  ["jaq"]="🚀 jaq"
  ["jc"]="🚀 jc"
  ["jira-cli"]="🚀 jira-cli"
  ["jj"]="🚀 jj"
  ["jless"]="🚀 jless"
  ["jnv"]="🚀 jnv"
  ["jo"]="🚀 jo"
  ["joshuto"]="🚀 joshuto"
  ["jq"]="🚀 jq"
  ["jql"]="🚀 jql"
  ["jqp"]="🚀 jqp"
  ["jujutsu"]="🚀 jujutsu"
  ["just"]="🚀 just"
  ["k3d"]="🚀 k3d"
  ["k3s"]="🚀 k3s"
  ["k6"]="🚀 k6"
  ["k8sgpt"]="🚀 k8sgpt"
  ["k9s-cli"]="🚀 k9s-cli"
  ["kakoune"]="🚀 kakoune"
  ["kalker"]="🚀 kalker"
  ["kaskade"]="🚀 kaskade"
  ["kcl"]="🚀 kcl"
  ["kdash"]="🚀 kdash"
  ["kew"]="🚀 kew"
  ["kind"]="🚀 kind"
  ["klog"]="🚀 klog"
  ["kmon"]="🚀 kmon"
  ["ko"]="🚀 ko"
  ["kondo"]="🚀 kondo"
  ["krew"]="🚀 krew"
  ["kubecolor"]="🚀 kubecolor"
  ["kubectl"]="🚀 kubectl"
  ["kubectx"]="🚀 kubectx"
  ["kubens"]="🚀 kubens"
  ["kubent"]="🚀 kubent"
  ["kustomize"]="🚀 kustomize"
  ["lapce"]="🚀 lapce"
  ["lazydocker"]="🚀 lazydocker"
  ["lazygit"]="🚀 lazygit"
  ["lazygit-tui"]="🚀 lazygit-tui"
  ["lazynpm"]="🚀 lazynpm"
  ["lazysql"]="🚀 lazysql"
  ["lazyvim"]="🚀 lazyvim"
  ["lefthook"]="🚀 lefthook"
  ["lens"]="🚀 lens"
  ["lf"]="🚀 lf"
  ["litecli"]="🚀 litecli"
  ["llm"]="🚀 llm"
  ["lmstudio"]="🚀 lmstudio"
  ["lnav"]="🚀 lnav"
  ["lolcat"]="🚀 lolcat"
  ["lsd"]="🚀 lsd"
  ["lychee"]="🚀 lychee"
  ["macchina"]="🚀 macchina"
  ["mani"]="🚀 mani"
  ["marimo"]="🚀 marimo"
  ["mcfly"]="🚀 mcfly"
  ["mdcat"]="🚀 mdcat"
  ["melt"]="🚀 melt"
  ["micro"]="🚀 micro"
  ["miller"]="🚀 miller"
  ["miniserve"]="🚀 miniserve"
  ["mise"]="🚀 mise"
  ["mkcert"]="🚀 mkcert"
  ["mlr"]="🚀 mlr"
  ["moar"]="🚀 moar"
  ["mods"]="🚀 mods"
  ["monolith"]="🚀 monolith"
  ["moon"]="🚀 moon"
  ["mprocs"]="🚀 mprocs"
  ["mycli"]="🚀 mycli"
  ["mysql"]="🚀 mysql"
  ["nap"]="🚀 nap"
  ["navi"]="🚀 navi"
  ["ncdu"]="🚀 ncdu"
  ["ncspot"]="🚀 ncspot"
  ["neofetch-alt"]="🚀 neofetch-alt"
  ["neovim"]="🚀 neovim"
  ["netlify"]="🚀 netlify"
  ["newsboat"]="🚀 newsboat"
  ["ngrok"]="🚀 ngrok"
  ["nix"]="🚀 nix"
  ["nnn"]="🚀 nnn"
  ["nomad"]="🚀 nomad"
  ["nuclei"]="🚀 nuclei"
  ["numbat"]="🚀 numbat"
  ["nushell"]="🚀 nushell"
  ["obsidian"]="🚀 obsidian"
  ["oh-my-posh"]="🚀 oh-my-posh"
  ["oha"]="🚀 oha"
  ["ollama"]="🚀 ollama"
  ["onefetch"]="🚀 onefetch"
  ["open-interpreter"]="🚀 open-interpreter"
  ["opentofu"]="🚀 opentofu"
  ["ouch"]="🚀 ouch"
  ["oxker"]="🚀 oxker"
  ["oxlint"]="🚀 oxlint"
  ["packer"]="🚀 packer"
  ["pastel"]="🚀 pastel"
  ["peco"]="🚀 peco"
  ["pgcli"]="🚀 pgcli"
  ["pipes-rs"]="🚀 pipes-rs"
  ["pipes-sh"]="🚀 pipes-sh"
  ["pixi"]="🚀 pixi"
  ["pkgx"]="🚀 pkgx"
  ["plandex"]="🚀 plandex"
  ["pls"]="🚀 pls"
  ["pnpm"]="🚀 pnpm"
  ["podman"]="🚀 podman"
  ["poetry"]="🚀 poetry"
  ["pokeget"]="🚀 pokeget"
  ["pomsky"]="🚀 pomsky"
  ["popeye"]="🚀 popeye"
  ["porsmo"]="🚀 porsmo"
  ["posting"]="🚀 posting"
  ["presenterm"]="🚀 presenterm"
  ["procs"]="🚀 procs"
  ["proto"]="🚀 proto"
  ["pueue"]="🚀 pueue"
  ["pulumi"]="🚀 pulumi"
  ["px"]="🚀 px"
  ["qsv"]="🚀 qsv"
  ["repomix"]="🚀 repomix"
  ["rio"]="🚀 rio"
  ["rip"]="🚀 rip"
  ["ripgrep"]="🚀 ripgrep"
  ["ripgrep_all"]="🚀 ripgrep_all"
  ["rnr"]="🚀 rnr"
  ["rs-cmatrix"]="🚀 rs-cmatrix"
  ["ruff"]="🚀 ruff"
  ["ruplacer"]="🚀 ruplacer"
  ["rustscan"]="🚀 rustscan"
  ["rye"]="🚀 rye"
  ["sad"]="🚀 sad"
  ["scc"]="🚀 scc"
  ["sd"]="🚀 sd"
  ["serie"]="🚀 serie"
  ["serpl"]="🚀 serpl"
  ["sesh"]="🚀 sesh"
  ["shell-gpt"]="🚀 shell-gpt"
  ["shellcheck"]="🚀 shellcheck"
  ["shfmt"]="🚀 shfmt"
  ["silicon"]="🚀 silicon"
  ["skate"]="🚀 skate"
  ["skim"]="🚀 skim"
  ["slack"]="🚀 slack"
  ["slides"]="🚀 slides"
  ["slumber"]="🚀 slumber"
  ["sniffnet"]="🚀 sniffnet"
  ["so"]="🚀 so"
  ["sops"]="🚀 sops"
  ["spacer"]="🚀 spacer"
  ["spt"]="🚀 spt"
  ["sqlc"]="🚀 sqlc"
  ["starship"]="🚀 starship"
  ["steampipe"]="🚀 steampipe"
  ["stern"]="🚀 stern"
  ["stripe"]="🚀 stripe"
  ["supabase"]="🚀 supabase"
  ["superfile"]="🚀 superfile"
  ["syft"]="🚀 syft"
  ["systemctl-tui"]="🚀 systemctl-tui"
  ["systeroid"]="🚀 systeroid"
  ["sysz"]="🚀 sysz"
  ["t-rec"]="🚀 t-rec"
  ["tailspin"]="🚀 tailspin"
  ["taplo"]="🚀 taplo"
  ["task"]="🚀 task"
  ["taskwarrior-tui"]="🚀 taskwarrior-tui"
  ["tealdeer"]="🚀 tealdeer"
  ["television"]="🚀 television"
  ["tenki"]="🚀 tenki"
  ["tenv"]="🚀 tenv"
  ["tere"]="🚀 tere"
  ["termdbms"]="🚀 termdbms"
  ["termscp"]="🚀 termscp"
  ["termshark"]="🚀 termshark"
  ["termtyper"]="🚀 termtyper"
  ["terragrunt"]="🚀 terragrunt"
  ["tflint"]="🚀 tflint"
  ["tfsec"]="🚀 tfsec"
  ["tgpt"]="🚀 tgpt"
  ["thefuck"]="🚀 thefuck"
  ["tickrs"]="🚀 tickrs"
  ["tig"]="🚀 tig"
  ["tilt"]="🚀 tilt"
  ["tin-summer"]="🚀 tin-summer"
  ["tldr"]="🚀 tldr"
  ["tlrc"]="🚀 tlrc"
  ["tmate"]="🚀 tmate"
  ["tmux"]="🚀 tmux"
  ["tokei"]="🚀 tokei"
  ["topgrade"]="🚀 topgrade"
  ["trash-cli"]="🚀 trash-cli"
  ["tre"]="🚀 tre"
  ["trippy"]="🚀 trippy"
  ["trivy"]="🚀 trivy"
  ["trufflehog"]="🚀 trufflehog"
  ["trzsz"]="🚀 trzsz"
  ["tt"]="🚀 tt"
  ["ttyd"]="🚀 ttyd"
  ["ttyper"]="🚀 ttyper"
  ["turso"]="🚀 turso"
  ["typos"]="🚀 typos"
  ["typos-cli"]="🚀 typos-cli"
  ["typst"]="🚀 typst"
  ["ugit"]="🚀 ugit"
  ["ugrep"]="🚀 ugrep"
  ["usql"]="🚀 usql"
  ["uv"]="🚀 uv"
  ["vault"]="🚀 vault"
  ["vcluster"]="🚀 vcluster"
  ["vegeta"]="🚀 vegeta"
  ["vercel"]="🚀 vercel"
  ["vhs"]="🚀 vhs"
  ["viddy"]="🚀 viddy"
  ["visidata"]="🚀 visidata"
  ["viu"]="🚀 viu"
  ["vivid"]="🚀 vivid"
  ["vscode"]="🚀 vscode"
  ["walk"]="🚀 walk"
  ["warp"]="🚀 warp"
  ["watchexec"]="🚀 watchexec"
  ["waypoint"]="🚀 waypoint"
  ["websocat"]="🚀 websocat"
  ["wezterm"]="🚀 wezterm"
  ["wiki-tui"]="🚀 wiki-tui"
  ["windsurf"]="🚀 windsurf"
  ["wtf"]="🚀 wtf"
  ["wtfutil"]="🚀 wtfutil"
  ["wthrr"]="🚀 wthrr"
  ["wthrr-the-weathercrab"]="🚀 wthrr-the-weathercrab"
  ["wuzz"]="🚀 wuzz"
  ["xc"]="🚀 xc"
  ["xcp"]="🚀 xcp"
  ["xh"]="🚀 xh"
  ["xplr"]="🚀 xplr"
  ["xsv"]="🚀 xsv"
  ["yamlfmt"]="🚀 yamlfmt"
  ["yazi"]="🚀 yazi"
  ["yq"]="🚀 yq"
  ["yt-dlp"]="🚀 yt-dlp"
  ["zed"]="🚀 zed"
  ["zellij"]="🚀 zellij"
  ["zen-browser"]="🚀 zen-browser"
  ["zenith"]="🚀 zenith"
  ["zig"]="🚀 zig"
  ["zizmor"]="🚀 zizmor"
  ["zoxide"]="🚀 zoxide"
  ["zrok"]="🚀 zrok"
  ["zsh"]="🚀 zsh"
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
