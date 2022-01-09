echo -p generating ssh
ssh-keygen
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub
xclip -sel clip < ~/.ssh/id_rsa.pub

# Copy SSH to server
# ssh-copy-id -i ~/.ssh/id_rsa.pub <user>@<server>
