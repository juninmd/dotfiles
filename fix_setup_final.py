import re
import os

with open('setup-2026.sh', 'r') as f:
    content = f.read()


# We need to make sure the fix is actually applied. Let's do it forcefully.
def extract_array(profile, text):
    match = re.search(r'' + profile + r'\)\n\s*DEFAULT_MODULES=\((.*?)\)', text)
    if not match:
        return []
    return match.group(1).split()

def set_array(profile, text, new_arr):
    match = re.search(r'' + profile + r'\)\n\s*DEFAULT_MODULES=\((.*?)\)', text)
    if not match:
        return text
    return text[:match.start(1)] + " ".join(new_arr) + text[match.end(1):]


full_mods = extract_array('full', content)
ai_dev_mods = extract_array('ai-dev', content)

mods_in_dir = set()
for mod in os.listdir('programas/'):
    if os.path.isdir(os.path.join('programas/', mod)) and mod != 'common':
        mods_in_dir.add(mod)

# The user explicitly asked to "add more usefull 2026 apps"
desktop_apps = {'brave', 'discord', 'firefox', 'android', 'slack'}

cli_tools = ['trippy', 'onefetch', 'grex', 'bandwhich', 'amber', 'tailspin', 'erdtree', 'dua', 'oxlint', 'difftastic', 'topgrade', 'pastel', 'numbat', 'dufs', 'jj', 'sesh', 'carapace', 'moar', 'vhs', 'gitleaks', 'xc', 'gdu', 'trash-cli', 'yt-dlp', 'glances', 'd2', 'poetry', 'pnpm', 'fnm', 'gping', 'kondo', 'presenterm', 'hexyl', 'csvlens', 'pomsky', 'bacon', 'wiki-tui', 'ast-grep', 'dive', 'gron', 'viddy', 'wtfutil', 'cointop', 'dasel', 'dust', 'navi', 'delta', 'websocat', 'ouch', 'zenith', 'git-cliff', 'typos', 'fend', 'joshuto', 'sniffnet', 'termscp', 'wthrr', 'miniserve', 'zizmor', 'inlyne', 'so', 'xcp', 'taplo', 'tlrc', 'typst', 'xsv', 'gh', 'act', 'task', 'croc', 'dbmate', 'ripgrep_all', 'kubens', 'doppler', 'infisical', 'stripe', 'awscli', 'vercel', 'pulumi', 'terragrunt', 'tflint', 'ttyd', 'argc', 'argocd', 'k3s', 'vault', 'bw', 'netlify', 'heroku', 'consul', 'nomad', 'packer', 'aider-chat', 'typos-cli', 'wthrr-the-weathercrab', 'bruno-cli', 'wtf', 'mlr', 'pls', 'devtoy', 'git-next', 'tmux', 'htop', 'cmatrix', 'vivid', 'hadolint', 'ugit', 'pgcli', 'mycli', 'litecli', 'tere', 'kubent', 'lazyvim', 'oh-my-posh', 'gptme', 'micro', 'nnn', 'tig', 'ncdu', 'kakoune', 'aqua', 'kcl', 'devspace', 'lazygit', 'lens', 'marimo', 'bito', 'gorilla-cli', 'ffuf', 'tmate', 'kaskade', 'boundary', 'waypoint', 'pixi', 'proto', 'rio', 'lapce']

changed = False

# Make sure all ai-dev tools are in ai_dev_mods
for m in cli_tools:
    if m not in ai_dev_mods and m in mods_in_dir and m not in desktop_apps:
        ai_dev_mods.append(m)
        changed = True

# Also ensure some fastfetch tools and missing ones
extra_ai_dev_tools = ['fastfetch', 'hck', 'termshark', 'kmon']
for tool in extra_ai_dev_tools:
    if tool not in ai_dev_mods and tool in mods_in_dir:
        ai_dev_mods.append(tool)
        changed = True

for m in mods_in_dir:
    if m not in full_mods:
        full_mods.append(m)
        changed = True

content = set_array('full', content, full_mods)
content = set_array('ai-dev', content, ai_dev_mods)

# Fix commas in descriptions
def comma_replacer(match):
    desc = match.group(1).replace(',', '/')
    return f'"{desc}"'
new_content = re.sub(r'\[".*?"\]="([^"]+)"', lambda m: m.group(0).replace(m.group(1), m.group(1).replace(',', '/')), content)
if new_content != content:
    changed = True
    content = new_content

# Remove generic descriptions
new_content = re.sub(r'\["(.*?)"\]="🚀 \1 \(Ferramenta CLI moderna\)"', r'["\1"]="🚀 \1 (Utilitário \1)"', content)
if new_content != content:
    changed = True
    content = new_content

new_content = re.sub(r'\["(.*?)"\]="🚀 \1 \(App/Tool\)"', r'["\1"]="🚀 \1 (Utilitário \1)"', content)
if new_content != content:
    changed = True
    content = new_content

# Add missing MOD_DESC entries
for mod in mods_in_dir:
    if f'["{mod}"]=' not in content:
        match = re.search(r'declare -A MOD_DESC=\((.*?)\)', content, re.DOTALL)
        if match:
            new_entry = f'\n  ["{mod}"]="🚀 {mod} (Utilitário {mod})"'
            content = content[:match.end(1)] + new_entry + content[match.end(1):]
            changed = True

if changed:
    with open('setup-2026.sh', 'w') as f:
        f.write(content)
    print("Changes were made.")
else:
    print("No changes were needed.")
