#!/bin/bash
c='\e[32m'
r='\e[0m'
# Krew (Kubectl plugin manager)
if ! command -v kubectl-krew &> /dev/null; then
    echo -e "${c}Installing Krew...${r}"
    (
      set -x; cd "$(mktemp -d)" &&
      OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
      local arch
      arch="$(uname -m)"
      case "$arch" in
        x86_64) ARCH="amd64" ;;
        aarch64 | arm64) ARCH="arm64" ;;
        arm*) ARCH="arm" ;;
        *)
          echo "Arquitetura não suportada para o Krew: $arch" >&2
          exit 1
          ;;
      esac
      KREW="krew-${OS}_${ARCH}" &&
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && # NOSONAR
      tar zxf "${KREW}.tar.gz" &&
      ./"${KREW}" install krew
    )
else
    echo -e "${c}Krew already installed.${r}"
fi
