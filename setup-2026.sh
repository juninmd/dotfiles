#!/usr/bin/env bash
set -euo pipefail

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
Uso: ./setup-2026.sh [--dry-run] [--profile minimal|dev|full]

Perfis:
  minimal  -> shell moderna + prompt + editor
  dev      -> minimal + runtime JS + docker + banco
  full     -> dev + ferramentas extras de produtividade
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

run_module() {
  local module="$1"
  local script="$ROOT_DIR/programas/$module/setup.sh"

  if [[ ! -x "$script" ]]; then
    chmod +x "$script"
  fi

  if [[ "$DRY_RUN" == true ]]; then
    run_step "Executando módulo: $module" "$script"
  else
    if command -v "$GUM" &> /dev/null; then
      "$GUM" spin --spinner dot --title "$($GUM style --foreground "#72f1b8" "Executando módulo: $module...")" -- bash -c '"$1" > "/tmp/setup-2026-$2.log" 2>&1' -- "$script" "$module"
    else
      run_step "Executando módulo: $module" "$script"
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
    "$GUM" style \
      --foreground "#fede5d" --border-foreground "#bd93f9" --border double \
      --align center --width 60 --margin "1 2" --padding "2 4" \
      '⚡ DOTFILES 2026 EDITION ⚡' 'O Futuro do Desenvolvimento'

    echo ""
    "$GUM" style --foreground "#36f9f6" "🚀 Escolha o perfil de instalação para turbinar sua máquina:"
    echo ""
    PROFILE_CHOICE=$("$GUM" choose \
      --cursor="👉 " \
      --header="Selecione um perfil abaixo:" \
      --header.foreground="#ff7edb" \
      --cursor.foreground="#36f9f6" \
      --item.foreground="#f8f8f2" \
      --selected.foreground="#72f1b8" \
      "minimal   - Shell moderna, prompt limpo e editor básico." \
      "dev       - minimal + Runtimes JS/Python, Docker e Banco de Dados (Recomendado)." \
      "full      - dev + Apps extras de produtividade (Navegador, Slack, etc).")
    PROFILE=$(echo "$PROFILE_CHOICE" | awk '{print $1}')
  else
    read -rp "Escolha o perfil (minimal, dev, full) [full]: " PROFILE
    PROFILE=${PROFILE:-full}
  fi
fi

case "$PROFILE" in
  minimal)
    DEFAULT_MODULES=(cli-tools zsh starship vscode)
    ;;
  dev)
    DEFAULT_MODULES=(cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi)
    ;;
  full)
    DEFAULT_MODULES=(cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi firefox slack)
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
  ["android"]="Android Studio & SDK"
  ["bun"]="Bun JavaScript runtime"
  ["cli-tools"]="Ferramentas CLI modernas (2026 apps)"
  ["firefox"]="Navegador Firefox"
  ["lazydocker"]="LazyDocker TUI"
  ["lazygit"]="LazyGit TUI"
  ["mysql"]="MySQL Server & Client"
  ["slack"]="Slack Desktop"
  ["starship"]="Starship Prompt"
  ["vscode"]="Visual Studio Code"
  ["yazi"]="Yazi File Manager"
  ["zellij"]="Zellij Terminal Multiplexer"
  ["zsh"]="Zsh shell e plugins"
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
  "$GUM" style --foreground "#36f9f6" "Selecione os módulos que deseja instalar (Espaço para marcar/desmarcar, Enter para confirmar):"
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
  SELECTED_TEXT=$("$GUM" choose --no-limit --cursor="👉 " \
    --selected="${DEFAULTS}" \
    --selected.foreground="#72f1b8" \
    --cursor.foreground="#36f9f6" \
    "${CHOICES[@]}")

  # Extract module directories from the selected text
  MODULES=()
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      mod=$(echo "$line" | awk '{print $1}')
      MODULES+=("$mod")
    fi
  done <<< "$SELECTED_TEXT"

  echo ""
  "$GUM" style --foreground "#72f1b8" --bold "📦 Módulos que serão instalados:"
  for mod in "${MODULES[@]}"; do
    if [ -n "$mod" ]; then
      desc="${MOD_DESC[$mod]:-Módulo $mod}"
      echo "  $($GUM style --foreground "#ff7edb" "•") $($GUM style --foreground "#fede5d" "$mod") $($GUM style --foreground "#6272a4" "($desc)")"
    fi
  done
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
    echo ""
    if ! "$GUM" confirm --unselected.background "" --unselected.foreground "#f8f8f2" --selected.background "#bd93f9" --selected.foreground "#282a36" "Deseja prosseguir com a instalação destes módulos e transformar seu setup?"; then
      log "Instalação cancelada pelo usuário."
      exit 0
    fi
    echo ""
  else
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

for module in "${MODULES[@]}"; do
  if [[ ! -f "$ROOT_DIR/programas/$module/setup.sh" ]]; then
    log "Módulo ignorado (setup inexistente): $module"
    continue
  fi

  run_module "$module"
done

if command -v "$GUM" &> /dev/null; then
  "$GUM" style \
    --foreground "#282a36" --background "#72f1b8" --border-foreground "#72f1b8" \
    --border rounded --align center --width 50 --margin "2 2" --padding "1 2" \
    "🎉 Instalação do perfil '$PROFILE' finalizada com sucesso!" "Por favor, feche este terminal e abra um novo para carregar todas as configurações."
else
  log "Finalizado com sucesso. Reinicie seu terminal."
fi

# Cleanup
if [ -n "$TMP_GUM_DIR" ] && [ -d "$TMP_GUM_DIR" ]; then
    rm -rf "$TMP_GUM_DIR"
fi
