echo -p generating ssh

ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ssh-keygen
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub
xclip -sel clip < ~/.ssh/id_rsa.pub