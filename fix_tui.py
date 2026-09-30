import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

# According to memory:
# "Do not use commas in MOD_DESC values (use slashes / instead) because gum choose --selected uses commas as delimiters and it breaks TUI pre-selection."
# I will replace commas with slashes in MOD_DESC lines.

match = re.search(r'declare -A MOD_DESC=\((.*?)\n\)', content, re.DOTALL)
if match:
    block = match.group(1)
    new_block_lines = []
    for line in block.split('\n'):
        if '["' in line and '"]=' in line:
            m = re.search(r'(\[".*?"\]=")(.*?)(")$', line)
            if m:
                prefix = m.group(1)
                desc = m.group(2)
                suffix = m.group(3)
                desc = desc.replace(',', '/')
                new_block_lines.append(f'{prefix}{desc}{suffix}')
            else:
                new_block_lines.append(line)
        else:
            new_block_lines.append(line)

    new_block = '\n'.join(new_block_lines)
    content = content.replace(block, new_block)

with open('setup-2026.sh', 'w') as f:
    f.write(content)
