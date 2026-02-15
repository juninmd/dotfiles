#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
PROFILE="full"

log() {
  printf '[2026-setup] %s\n' "$*"
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

log "Finalizado com sucesso."
