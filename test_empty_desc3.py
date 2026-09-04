with open('setup-2026.sh', 'r') as f:
    lines = f.readlines()

in_mod_desc = False
for i, line in enumerate(lines):
    if 'declare -A MOD_DESC=' in line:
        in_mod_desc = True
        continue
    if in_mod_desc:
        if line.strip() == ')':
            in_mod_desc = False
            continue
        if '["' in line and ']="' in line:
            desc = line.split(']="')[1].strip().strip('"')
            if 'App' in desc or 'Tool' in desc or 'app' in desc or 'tool' in desc or 'Ferramenta' in desc:
                print(f"Line {i+1}: {line.strip()}")
