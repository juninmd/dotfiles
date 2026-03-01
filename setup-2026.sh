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
    "$GUM" style --foreground 212 "[$($GUM style --foreground 250 "2026-setup")] $*"
  else
    printf '[2026-setup] %s\n' "$*"
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

  run_step "Executando módulo: $module" "$script"
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
    "$GUM" style \
      --foreground 212 --border-foreground 212 --border double \
      --align center --width 50 --margin "1 2" --padding "2 4" \
      '⚡ DOTFILES 2026 EDITION ⚡'

    echo "Escolha o perfil de instalação:"
    PROFILE=$("$GUM" choose "minimal" "dev" "full")
  else
    read -rp "Escolha o perfil (minimal, dev, full) [full]: " PROFILE
    PROFILE=${PROFILE:-full}
  fi
fi

case "$PROFILE" in
  minimal)
    MODULES=(cli-tools zsh starship vscode)
    ;;
  dev)
    MODULES=(cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi)
    ;;
  full)
    MODULES=(cli-tools zsh starship bun mysql lazygit lazydocker vscode zellij yazi)
    ;;
  *)
    log "Perfil inválido: $PROFILE"
    usage
    exit 1
    ;;
esac

log "Perfil selecionado: $PROFILE"
log "Módulos: ${MODULES[*]}"

for module in "${MODULES[@]}"; do
  if [[ ! -f "$ROOT_DIR/programas/$module/setup.sh" ]]; then
    log "Módulo ignorado (setup inexistente): $module"
    continue
  fi

  run_module "$module"
done

if command -v "$GUM" &> /dev/null; then
  "$GUM" style --foreground 46 --margin "1 2" "🎉 Finalizado com sucesso!"
else
  log "Finalizado com sucesso."
fi

# Cleanup
if [ -n "$TMP_GUM_DIR" ] && [ -d "$TMP_GUM_DIR" ]; then
    rm -rf "$TMP_GUM_DIR"
fi
