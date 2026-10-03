# Contribuindo com módulos

Cada módulo é uma entrada em `installer/catalog/catalog.json` e **precisa** ter passo para `linux`, `macos` e `windows` (o teste `plan.test.ts` garante).

```json
{ "id": "bat", "name": "bat", "desc": "cat com highlight", "category": "cli",
  "install": {
    "linux":   { "kind": "apt",    "ref": "bat" },
    "macos":   { "kind": "brew",   "ref": "bat" },
    "windows": { "kind": "winget", "ref": "sharkdp.bat" } } }
```

Tipos: `apt`, `brew`, `cask`, `winget`, `script` (caminho em `programas/`). Refs só aceitam `[A-Za-z0-9._/-]`.

```sh
cd installer && bun test && bun run typecheck
```

## Cobertura e origem do catálogo

Todos os módulos de `programas/` instalam no Linux via script. Os IDs de Homebrew vêm do índice público `formulae.brew.sh` e os de winget de `winget search`, casando só por nome exato; colisões conhecidas (mesmo nome, outra ferramenta) ficam de fora até alguém indicar o ID certo. Veja a cobertura por sistema no [catálogo](/catalog).
