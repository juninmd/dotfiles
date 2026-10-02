---
title: Download
---

# Download

<DownloadCard />

## Pré-requisitos

| Sistema | Gerenciador usado | Observação |
|---|---|---|
| Windows 10/11 | `winget` | Já vem no Windows 11; no 10 instale o *App Installer*. |
| macOS 13+ | `brew` | Instale em <https://brew.sh> antes. |
| Linux (Debian/Ubuntu) | `apt` + scripts de `programas/` | `sudo` necessário. |

## Verificar manualmente

```sh
sha256sum -c SHA256SUMS --ignore-missing
```

## Simular sem instalar

```sh
dotfiles --profile dev --dry-run
```
