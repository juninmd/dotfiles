import os
import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

programas = [d for d in os.listdir('programas') if os.path.isdir(os.path.join('programas', d))]
programas = sorted(programas)
if 'common' in programas:
    programas.remove('common')
if 'cli-tools' in programas:
    programas.remove('cli-tools')

match = re.search(r'declare -A MOD_DESC=\((.*?)\n\)', content, re.DOTALL)
current_mods = {}
if match:
    for line in match.group(1).split('\n'):
        m = re.search(r'\["(.*?)"\]="(.*?)"', line)
        if m:
            current_mods[m.group(1)] = m.group(2)

new_mods_lines = []
for p in programas:
    if p in current_mods:
        new_mods_lines.append(f'  ["{p}"]="{current_mods[p]}"')
    else:
        new_mods_lines.append(f'  ["{p}"]="🚀 {p} (App/Tool)"')

new_mods_block = 'declare -A MOD_DESC=(\n' + '\n'.join(new_mods_lines) + '\n)'

# Let's do a more precise replacement using the exact prefix and suffix that we can easily find
parts = content.split('declare -A MOD_DESC=(')
part1 = parts[0]
part2 = parts[1]

end_idx = part2.find('\n)\n')
part2_rest = part2[end_idx+3:]

new_content = part1 + new_mods_block + '\n' + part2_rest

with open('setup-2026-new.sh', 'w') as f:
    f.write(new_content)
