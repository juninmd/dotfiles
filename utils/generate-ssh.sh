echo -p generating ssh
ssh-keygen
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub

## Copy Key if Linux
sudo apt-get update
sudo apt install xclip -y
xclip -sel clip < ~/.ssh/id_rsa.pub

## Copy key if wsdl
cat ~/.ssh/id_rsa.pub | clip.exe

# Copy SSH to server
# ssh-copy-id -i ~/.ssh/id_rsa.pub <user>@<server>
