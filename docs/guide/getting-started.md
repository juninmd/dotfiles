# Começando

1. Baixe o instalador na página de [download](/download).
2. Rode `dotfiles` e escolha um [perfil](/guide/profiles).
3. Revise o plano e confirme. Use `--dry-run` para só simular.

```text
dotfiles [--profile <nome>] [--dry-run] [--yes]
```

## Dentro do repositório (Linux)

```bash
git clone https://github.com/juninmd/dotfiles.git && cd dotfiles
./setup-2026.sh --profile dev --dry-run
```

Os scripts legados (`setup.sh`, `setup-2026.sh`) continuam funcionando; o instalador novo reaproveita `programas/*/setup.sh` no Linux.
