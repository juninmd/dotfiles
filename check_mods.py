import re
import os

with open('setup-2026.sh', 'r') as f:
    content = f.read()

match = re.search(r'declare -A MOD_DESC=\((.*?)\n\)', content, re.DOTALL)
mod_descs = []
if match:
    for line in match.group(1).split('\n'):
        m = re.search(r'\["(.*?)"\]=', line)
        if m:
            mod_descs.append(m.group(1))

programas = [d for d in os.listdir('programas') if os.path.isdir(os.path.join('programas', d))]

missing_from_desc = [p for p in programas if p not in mod_descs]
print(f"Missing from MOD_DESC: {missing_from_desc}")

full_match = re.search(r'full\)\s*DEFAULT_MODULES=\((.*?)\)', content, re.DOTALL)
if full_match:
    full_mods = full_match.group(1).split()
    missing_from_full = [p for p in programas if p not in full_mods]
    print(f"Missing from full profile: {missing_from_full}")
