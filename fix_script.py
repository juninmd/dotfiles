with open("setup-2026.sh", "r") as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if line.strip() == "":
        # We might have replaced `--height=20 \` with just a blank line
        # but the script already has blank lines. Let's just remove blank lines that were meant to be options?
        pass

# Let's fix the bash line continuation by deleting the empty lines before `--cursor` or `--selected` that we introduced
# To be safe, I'll just remove the lines that are empty AND part of the gum command
