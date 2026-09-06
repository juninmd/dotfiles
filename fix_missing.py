import re
import os

with open('setup-2026.sh', 'r') as f:
    content = f.read()

# Replace neofetch-alt with fastfetch in full if missing (it might be fastfetch instead of neofetch-alt, but wait, both are in memory?)
# The user prompt memory says: 'Fastfetch is installed via PPA ...' and 'Modern CLI replacements include ... neofetch-alt ...'

# Let's fix descriptions in MOD_DESC:
replacements = [
    ('["age"]="📦 age (A simple modern and secure file encryption tool)"', '["age"]="📦 age (Criptografia moderna de arquivos)"'),
    ('["atlas"]="📦 atlas (Modern tool for managing database schemas)"', '["atlas"]="📦 atlas (Gerenciador moderno de esquemas de banco de dados)"'),
    ('["bat-extras"]="🦇 bat-extras (Bash scripts that integrate bat with various command line tools)"', '["bat-extras"]="🦇 bat-extras (Scripts bash que integram bat com utilitários cli)"'),
    ('["biome"]="🚀 Biome (Fast JS TS toolchain)"', '["biome"]="🚀 Biome (Conjunto de utilitários rápidos JS/TS)"'),
    ('["charm"]="✨ charm (Charmbracelet tool)"', '["charm"]="✨ charm (Utilitário Charmbracelet)"'),
    ('["cli-tools"]="🧰 Dependências Base 2026 (Rust Go Python build-tools)"', '["cli-tools"]="🧰 Dependências Base 2026 (Rust Go Python build-utils)"'),
    ('["dapr"]="📦 Dapr CLI (Modern tool for building distributed applications)"', '["dapr"]="📦 Dapr CLI (CLI para construção de aplicações distribuídas)"'),
    ('["dbmate"]="🗃️ dbmate (Database migration tool)"', '["dbmate"]="🗃️ dbmate (Utilitário de migração de banco de dados)"'),
    ('["elixir"]="💧 Elixir (Dynamic functional language for building scalable and maintainable applications)"', '["elixir"]="💧 Elixir (Linguagem funcional dinâmica)"'),
    ('["bito"]="🤖 bito (AI CLI tool)"', '["bito"]="🤖 bito (CLI assistente de IA)"'),
    ('["heroku"]="☁️ Heroku CLI (Manage Heroku apps)"', '["heroku"]="☁️ Heroku CLI (Gerenciar plataformas Heroku)"'),
    ('["httpx"]="⚡ httpx (Fast and multi-purpose HTTP toolkit)"', '["httpx"]="⚡ httpx (Conjunto de utilitários HTTP rápido e multiuso)"'),
    ('["hyperfine"]="⏱️ Hyperfine (A command-line benchmarking tool)"', '["hyperfine"]="⏱️ Hyperfine (Utilitário de benchmarking em terminal)"'),
    ('["jql"]="🔍 jql (JSON query language CLI tool)"', '["jql"]="🔍 jql (Processador CLI para linguagem de consulta JSON)"'),
    ('["k6"]="🚀 k6 (Modern load testing tool)"', '["k6"]="🚀 k6 (Utilitário moderno de testes de carga)"'),
    ('["ko"]="📦 ko (Build and deploy Go applications on Kubernetes)"', '["ko"]="📦 ko (Build e deploy de aplicações Go no Kubernetes)"'),
    ('["kubectl"]="⎈ kubectl (Kubernetes command-line tool)"', '["kubectl"]="⎈ kubectl (Cliente de linha de comando para Kubernetes)"'),
    ('["mani"]="📂 mani (CLI tool to manage multiple repositories)"', '["mani"]="📂 mani (Utilitário CLI para gerenciar múltiplos repositórios)"'),
    ('["mise"]="🛠️ Mise (Polyglot Tool Version Manager)"', '["mise"]="🛠️ Mise (Gerenciador de versões poliglota)"'),
    ('["mkcert"]="🔐 mkcert (Simple zero-config tool to make locally trusted development certificates)"', '["mkcert"]="🔐 mkcert (Utilitário simples para certificados locais confiáveis)"'),
    ('["navi"]="🧭 navi (An interactive cheatsheet tool for the command-line)"', '["navi"]="🧭 navi (Cheatsheet interativa para linha de comando)"'),
    ('["pastel"]="🎨 pastel (Command-line Color Tool)"', '["pastel"]="🎨 pastel (Utilitário de cores para linha de comando)"'),
    ('["peco"]="🔍 peco (Simplistic interactive filtering tool)"', '["peco"]="🔍 peco (Utilitário interativo e simplista para filtragem)"'),
    ('["pueue"]="🗃️ Pueue (Command-line task management tool)"', '["pueue"]="🗃️ Pueue (Gerenciador de tarefas via linha de comando)"'),
    ('["qsv"]="📊 qsv (CSV data-wrangling toolkit)"', '["qsv"]="📊 qsv (Conjunto de utilitários para manipulação de dados CSV)"'),
    ('["ripgrep"]="⚡ Ripgrep (Line-oriented search tool)"', '["ripgrep"]="⚡ Ripgrep (Buscador orientado a linha ultra rápido)"'),
    ('["rnr"]="🔄 rnr (A command-line tool to rename files and directories safely)"', '["rnr"]="🔄 rnr (Utilitário seguro para renomear arquivos e diretórios)"'),
    ('["shellcheck"]="🐚 shellcheck (A static analysis tool for shell scripts)"', '["shellcheck"]="🐚 shellcheck (Analisador estático para shell scripts)"'),
    ('["slides"]="📊 slides (Terminal based presentation tool)"', '["slides"]="📊 slides (Apresentações baseadas em terminal)"'),
    ('["sops"]="🔐 sops (Simple and flexible tool for managing secrets)"', '["sops"]="🔐 sops (Utilitário simples e flexível para gerenciar segredos)"'),
    ('["spacer"]="📏 spacer (CLI tool to insert spacers when command output stops)"', '["spacer"]="📏 spacer (Insere espaçadores em saídas do terminal)"'),
    ('["syft"]="📦 syft (CLI tool and library for generating a SBOM)"', '["syft"]="📦 syft (Gerador de SBOM via CLI)"'),
    ('["taplo"]="⚙️ taplo (TOML toolkit)"', '["taplo"]="⚙️ taplo (Conjunto de utilitários para arquivos TOML)"'),
    ('["terragrunt"]="🏗️ Terragrunt (Thin wrapper for Terraform)"', '["terragrunt"]="🏗️ Terragrunt (Envolucro leve para Terraform)"'),
    ('["thefuck"]="🤬 thefuck (Magnificent app which corrects your previous console command)"', '["thefuck"]="🤬 thefuck (Corrige comandos digitados erroneamente)"'),
    ('["trzsz"]="📤 trzsz (A simple file transfer tools similar to lrzsz (rz sz) and compatible with tmux)"', '["trzsz"]="📤 trzsz (Transferência de arquivos simples compatível com tmux)"'),
    ('["vegeta"]="🔫 vegeta (HTTP load testing tool and library)"', '["vegeta"]="🔫 vegeta (Testes de carga HTTP e biblioteca)"'),
    ('["vercel"]="▲ Vercel CLI (Deploy serverless applications)"', '["vercel"]="▲ Vercel CLI (Deploy de aplicações serverless)"'),
    ('["visidata"]="📊 visidata (A terminal spreadsheet multitool for discovering and arranging data)"', '["visidata"]="📊 visidata (Planilha multiferramenta de terminal)"'),
    ('["waypoint"]="🎯 waypoint (Modern application deployment)"', '["waypoint"]="🎯 waypoint (Deploy moderno de aplicações)"'),
    ('["wuzz"]="🌐 wuzz (Interactive cli tool for HTTP inspection)"', '["wuzz"]="🌐 wuzz (Utilitário CLI interativo para inspeção HTTP)"'),
    ('["xh"]="🌐 xh (Friendly and fast tool for sending HTTP requests)"', '["xh"]="🌐 xh (Utilitário rápido e amigável para requests HTTP)"'),
    ('["xsv"]="📊 xsv (High performance CSV toolkit)"', '["xsv"]="📊 xsv (Conjunto de utilitários de alta performance para CSV)"'),
    ('["yamlfmt"]="✨ yamlfmt (An extensible command line tool or library to format yaml files)"', '["yamlfmt"]="✨ yamlfmt (Formatador extensível para arquivos YAML)"'),
    ('["zizmor"]="🛡️ zizmor (Static analysis tool for GitHub Actions)"', '["zizmor"]="🛡️ zizmor (Análise estática para GitHub Actions)"'),
]

for old, new in replacements:
    content = content.replace(old, new)


mods_in_dir = set()
for mod in os.listdir('programas/'):
    if os.path.isdir(os.path.join('programas/', mod)) and mod != 'common':
        mods_in_dir.add(mod)


# Fix full profile
match_full = re.search(r'full\)\n\s*DEFAULT_MODULES=\((.*?)\)', content)
full_mods = match_full.group(1).split()
for m in mods_in_dir:
    if m not in full_mods:
        full_mods.append(m)
# Do NOT alphabetize! Keep the order!
# Append to the end!
content = content[:match_full.start(1)] + " ".join(full_mods) + content[match_full.end(1):]


# Fix ai-dev profile
# The prompt memory says: 'Modern CLI replacements include: eza, bat, zoxide, ...'
# 'ai-dev adds Ollama, Claude Code, Cursor, Zed, Warp, Zen Browser, LM Studio, Bruno, WezTerm, DBeaver, Windsurf, k9s-cli, posting, superfile, aider, plandex, open-interpreter, duckdb, harlequin, neofetch-alt, lazysql, gitingest, repomix, shell-gpt, atac, dsq, t-rec, cbonsai, pipes-sh, mprocs, aichat, fabric, k8sgpt, tgpt, jo, k6, television, code2prompt, jan, chatbox, inshellisense, podman, devpod, daytona, mods, llm, cline, gptme, bito, gorilla-cli, and marimo as standalone modules'
# AND 'full includes all dev modules plus extra browser/productivity tools, and an expanded suite of 2026 CLI apps (like trippy, onefetch, grex, bandwhich, amber, tailspin, erdtree, dua, oxlint, difftastic, topgrade, pastel, numbat, dufs, jj, sesh, carapace, moar, vhs, gitleaks, xc, gdu, trash-cli, yt-dlp, glances, d2, pnpm, fnm, gping, kondo, presenterm, hexyl, csvlens, pomsky, bacon, wiki-tui, ast-grep, dive, gron, viddy, wtfutil, cointop, dasel, dust, navi, delta, websocat, ouch, zenith, git-cliff, typos, fend, joshuto, sniffnet, termscp, wthrr, miniserve, zizmor, inlyne, so, xcp, taplo, tlrc, typst, xsv, gh, act, task, croc, dbmate, ripgrep_all, kubens, doppler, infisical, stripe, awscli, vercel, pulumi, terragrunt, tflint, ttyd, argc, argocd, k3s, vault, bw, netlify, heroku, consul, nomad, packer, aider-chat, typos-cli, wthrr-the-weathercrab, bruno-cli, wtf, mlr, pls, devtoy, git-next, tmux, htop, cmatrix, vivid, hadolint, ugit, pgcli, mycli, litecli, tere, kubent, lazyvim, oh-my-posh, gptme, micro, nnn, tig, ncdu, kakoune, aqua, kcl, devspace, lazygit, lens, marimo, bito, gorilla-cli, ffuf, tmate, kaskade, boundary, waypoint, pixi, proto, rio, and lapce)'
#
# Since the user specifically asks to add more useful 2026 apps in ai-dev, let's just make sure all of the above that we can gleam from the prompt is added to ai-dev. However, the review says: "The agent completely overwrote the ai-dev profile's DEFAULT_MODULES array with the exact same string used for the full profile. This destroys the distinction between the environments and forces the installation of unwanted desktop applications (e.g., brave, discord, firefox) in the ai-dev setup."
# So we need to only add CLI tools to ai-dev. We should explicitly NOT add desktop apps like brave, discord, firefox, android, obs-studio, slack, wezterm (wait, wezterm is already in ai-dev, so that's fine).
# Let's collect the list of "extra browser/productivity tools" that shouldn't be in ai-dev: brave, discord, firefox, android, slack.
# Is that all?

desktop_apps = {'brave', 'discord', 'firefox', 'android', 'slack'}

# Actually, the user says "add more usefull 2026 apps" and the review says "forces the installation of unwanted desktop applications (e.g., brave, discord, firefox) in the ai-dev setup."
# Let's add everything except desktop apps to ai-dev. Or wait, maybe we should just add the ones explicitly mentioned for ai-dev?
# The review said: "The agent completely overwrote the ai-dev profile's DEFAULT_MODULES array with the exact same string used for the full profile. This destroys the distinction between the environments and forces the installation of unwanted desktop applications (e.g., brave, discord, firefox) in the ai-dev setup."
# So I should ONLY append missing CLI tools, avoiding those.

# Let's extract the list of missing CLI tools from the memory and add them to ai-dev.
# Memory lists:
cli_tools = ['trippy', 'onefetch', 'grex', 'bandwhich', 'amber', 'tailspin', 'erdtree', 'dua', 'oxlint', 'difftastic', 'topgrade', 'pastel', 'numbat', 'dufs', 'jj', 'sesh', 'carapace', 'moar', 'vhs', 'gitleaks', 'xc', 'gdu', 'trash-cli', 'yt-dlp', 'glances', 'd2', 'poetry', 'pnpm', 'fnm', 'gping', 'kondo', 'presenterm', 'hexyl', 'csvlens', 'pomsky', 'bacon', 'wiki-tui', 'ast-grep', 'dive', 'gron', 'viddy', 'wtfutil', 'cointop', 'dasel', 'dust', 'navi', 'delta', 'websocat', 'ouch', 'zenith', 'git-cliff', 'typos', 'fend', 'joshuto', 'sniffnet', 'termscp', 'wthrr', 'miniserve', 'zizmor', 'inlyne', 'so', 'xcp', 'taplo', 'tlrc', 'typst', 'xsv', 'gh', 'act', 'task', 'croc', 'dbmate', 'ripgrep_all', 'kubens', 'doppler', 'infisical', 'stripe', 'awscli', 'vercel', 'pulumi', 'terragrunt', 'tflint', 'ttyd', 'argc', 'argocd', 'k3s', 'vault', 'bw', 'netlify', 'heroku', 'consul', 'nomad', 'packer', 'aider-chat', 'typos-cli', 'wthrr-the-weathercrab', 'bruno-cli', 'wtf', 'mlr', 'pls', 'devtoy', 'git-next', 'tmux', 'htop', 'cmatrix', 'vivid', 'hadolint', 'ugit', 'pgcli', 'mycli', 'litecli', 'tere', 'kubent', 'lazyvim', 'oh-my-posh', 'gptme', 'micro', 'nnn', 'tig', 'ncdu', 'kakoune', 'aqua', 'kcl', 'devspace', 'lazygit', 'lens', 'marimo', 'bito', 'gorilla-cli', 'ffuf', 'tmate', 'kaskade', 'boundary', 'waypoint', 'pixi', 'proto', 'rio', 'lapce']

match_ai_dev = re.search(r'ai-dev\)\n\s*DEFAULT_MODULES=\((.*?)\)', content)
ai_dev_mods = match_ai_dev.group(1).split()

for m in cli_tools:
    if m not in ai_dev_mods and m in mods_in_dir and m not in desktop_apps:
        ai_dev_mods.append(m)

# Make sure fastfetch is in ai-dev as well if it's not
if 'fastfetch' not in ai_dev_mods and 'fastfetch' in mods_in_dir:
    ai_dev_mods.append('fastfetch')

# Do NOT alphabetize! Keep the order!
content = content[:match_ai_dev.start(1)] + " ".join(ai_dev_mods) + content[match_ai_dev.end(1):]


with open('setup-2026.sh', 'w') as f:
    f.write(content)
