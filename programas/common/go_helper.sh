#!/usr/bin/env bash
set -euo pipefail

# Funcao auxiliar para instalar pacotes go
install_go_package() {
  local package="$1"
  if ! command -v go &> /dev/null; then
    echo "Go não está instalado. Instalando go..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y golang-go
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y golang
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm go
    else
        echo "Erro: Gerenciador de pacotes não suportado. Instale o Go manualmente."
        return 1
    fi
  fi

  # Adicionar $HOME/go/bin ao PATH se necessário no ambiente atual
  export PATH="$PATH:$HOME/go/bin"
  go install "$package"
}
