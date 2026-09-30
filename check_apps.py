import os
import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

# Extract MOD_DESC
mod_desc_match = re.search(r'declare -A MOD_DESC=\((.*?)\)', content, re.DOTALL)
if mod_desc_match:
    mod_descs = re.findall(r'\["(.*?)"\]=', mod_desc_match.group(1))
else:
    mod_descs = []

print(f"Total MOD_DESC entries: {len(mod_descs)}")

# Extract full profile modules
full_match = re.search(r'full\)\s*DEFAULT_MODULES=\((.*?)\)', content, re.DOTALL)
if full_match:
    full_mods = full_match.group(1).split()
else:
    full_mods = []

print(f"Total full profile modules: {len(full_mods)}")

# Check what's in programas/ but not in full_mods or mod_descs
programas = [d for d in os.listdir('programas') if os.path.isdir(os.path.join('programas', d))]
print(f"Total directories in programas: {len(programas)}")

missing_desc = [p for p in programas if p not in mod_descs]
missing_full = [p for p in programas if p not in full_mods]

print("Missing from MOD_DESC:", missing_desc)
print("Missing from full profile:", missing_full)
