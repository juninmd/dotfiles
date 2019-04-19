# Lista de itens para instalar


## cURL

```bash
sudo apt install curl
```

## xclip

```
sudo apt install xclip
```

## Git

```
sudo apt-get install git
git config --global user.email "xxxxxxx"
git config --global user.name "Antonio"
```

## zsh

```
sudo apt-get install zsh
```

```text
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

```
You can use zsh-nvm or enable it yourself by adding following lines to your ~/.zshrc

 export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

https://askubuntu.com/questions/937284/how-can-i-update-gnome-shell-extensions-from-the-command-line
```

## VSCode

https://code.visualstudio.com/


## NVM

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

```shell
nvm install --lts
nvm use --lts
```

## Yarn

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

```bash
sudo apt-get update && sudo apt-get install yarn
```

## SSH 

```bash
ssh-keygen

eval `ssh-agent`

ssh-add ~/.ssh/id_rsa
```

### Generate new pub

```bash
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub
```

### Test Bitbucket

```bash
ssh -T git@bitbucket.org
```

## Java

```bash
sudo apt-get update && sudo apt-get upgrade  
sudo apt-get install software-properties-common  
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt install oracle-java11-installer
```
