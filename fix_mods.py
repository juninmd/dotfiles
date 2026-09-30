import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

match = re.search(r'declare -A MOD_DESC=\((.*?)\n\)', content, re.DOTALL)
if match:
    print(len(match.group(1).split('\n')))
else:
    print("Not found")
