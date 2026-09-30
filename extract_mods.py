import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

match = re.search(r'declare -A MOD_DESC=\(\s*(.*?)\s*\)', content, re.DOTALL)
if match:
    block = match.group(1)
    # print(block)
    lines = block.split('\n')
    mods = []
    for line in lines:
        m = re.search(r'\["(.*?)"\]=', line)
        if m:
            mods.append(m.group(1))
    print(len(mods))
    # print(mods)
else:
    print("Not found")
