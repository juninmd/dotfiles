import re

with open('setup-2026.sh', 'r') as f:
    content = f.read()

match = re.search(r'--header="🌟.*?--header.bold \\', content, re.DOTALL)
if match:
    print(match.group(0))
