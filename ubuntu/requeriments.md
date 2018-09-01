## cURL
```bash
sudo apt install curl
```

## xclip
```
sudo apt install xclip
```

## Git
https://git-scm.com/download/linux

git config --global user.email "xxxxxxx"
git config --global user.name "Antonio"

## VSCode
https://code.visualstudio.com/


## NVM
```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

```
nvm install --lts
nvm use --lts
```


## Yarn
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

```
sudo apt-get update && sudo apt-get install yarn
```

## SSH 
ssh-keygen 

eval `ssh-agent` 

ssh-add ~/.ssh/id_rsa

### Generate new pub
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub

## Test Bitbucket
ssh -T git@bitbucket.org

## Java
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install software-properties-common
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer