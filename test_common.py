import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

full_match = re.search(r'full\)\s*DEFAULT_MODULES=\((.*?)\)', content, re.DOTALL)
if full_match:
    full_mods = full_match.group(1).split()
    print("Is common in full_mods?", "common" in full_mods)
