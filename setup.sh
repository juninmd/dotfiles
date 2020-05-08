#!/bin/bash

##################################################################################################
# Author: Antonio                                                                                # 
# Credits: Shubham Pathk                                                                         # 
# Description: Auto setup bash script to setup required programs after doing fresh install.      # 
# Tested against Debian based distributions like Ubuntu 16.04/18.04 and Kali Linux.              #        
##################################################################################################

c='\e[32m' # Coloured echo (Green)
r='tput sgr0' #Reset colour after echo

# Required dependencies for all softwares (important)
echo -e "${c}Installing complete dependencies pack."; $r
sudo apt install -y software-properties-common apt-transport-https build-essential checkinstall libreadline-gplv2-dev libxssl libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev autoconf automake libtool make g++ unzip flex bison gcc libssl-dev libyaml-dev libreadline6-dev zlib1g zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libpq-dev libpcap-dev libmagickwand-dev libappindicator3-1 libindicator3-7 imagemagick xdg-utils

# Show Battery Percentage on Top Bar [Debian (gnome)]
if [ $XDG_CURRENT_DESKTOP == 'GNOME' ]; then
	gsettings set org.gnome.desktop.interface show-battery-percentage true
fi

# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y

#Snap Installation & Setup
echo -e "${c}Installing Snap & setting up."; $r
sudo apt install -y snapd
sudo systemctl start snapd
sudo systemctl enable snapd
sudo systemctl start apparmor
sudo systemctl enable apparmor
export PATH=$PATH:/snap/bin
sudo snap refresh

echo -e "${c}Install libavcodec-extra."; $r
sudo apt install -y libavcodec-extra

#Setting up Git
echo -e "${c}Installing Git"; $r
sudo apt -y install git

read -p "${c}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${c}Setting up Git"; $r
	(set -x; git --version )
	echo -e "${c}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${c}Git Setup Successfully!"; $r
else
	echo -e "${c}Skipping!"; $r && :
fi

#Installing curl and wget
echo -e "${c}Installing Curl and wget"; $r
sudo apt-get install -y wget curl

#Installing xclip
echo -e "${c}Installing xclip"; $r
sudo apt-get install -y xclip

#Installing zsh
echo -e "${c}Installing zsh"; $r
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#Installing dig
echo -e "${c}Installing DNS Utils"; $r
sudo apt install -y dnsutils

#Installing ADB and Fastboot
echo -e "${c}Installing ADB and Fastboot"; $r
sudo apt install -y android-tools-adb android-tools-fastboot

#Installing libc6
echo -e "${c}Installing libc6"; $r
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

#Installing gnome-tweak-tool
echo -e "${c}Installing Ubuntu Extensions"; $r
sudo apt install -y gnome-tweak-tool
sudo apt-get install chrome-gnome-shell -y

#Installing Media Codecs
sudo apt install ubuntu-restricted-extras -y

#Creating Directory Inside $HOME
echo -e "${c}Creating Directory named 'tools' inside $HOME directory."; $r
cd
mkdir -p tools

installGo() {
	echo -e "${c}Installing Go version 1.14.1"; $r #Latest version at the time of updating.
	cd
	wget -q https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.14.1.linux-amd64.tar.gz
	sudo rm -f go1.14.1.linux-amd64.tar.gz
	echo -e "${c}Setting up GOPATH as $HOME/go"; $r
	echo "export GOPATH=$HOME/go" >> ~/.profile
	echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin" >> ~/.profile
	source ~/.profile
	echo -e "${c}Go Installed Successfully."; $r
}

checkGo() {
	echo -e "${c}Checking if Go is installed."; $r
	source ~/.profile
	source ~/.bashrc
	if [[ -z $(which go) ]]; then
		echo -e "${c}Go is not installed, installing it first."; $r
		installGo
	else
		echo -e "${c}Go is already installed, Skipping."; $r
	fi
}
#Executing Install Dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
options=(1 "Visual Studio Code" on
	2 "Python2 and iPython" on
	3 "Python3" off
	4 "Go" off
	5 "Android Studio" off
	6 "Amazon Corretto" off
	7 "Chrome" off
	8 "Jadx (Java Decompiler)" off
	9 "httprobe" off
	10 "SQLMAP" off
	11 "i3 Window Manager" off
	12 "NodeJS" on
	13 "Wireshark" off
	14 "Knockpy" off
	15 "Dirsearch" off
	16 "LinkFinder" off
	17 "Virtual Box" off
  18 "Node Version Mananger" on
  19 "YARN" on
  20 "Java 11" on
	21 "MYSQL" on
  22 "Docker" on
  23 "Docker Compose" on
  24 "Telegram" on
  25 "Steam" on
  26 "VLC Media Player" on
	)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected
do
	case $choices in
		1) 
		echo -e "${c}Installing Visual Studio Code"; $r
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
		sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
		sudo apt update -y
		sudo apt install -y code
                sudo rm -f microsoft.gpg
		echo -e "${c}Visual Studio Code Installed Successfully."; $r
		;;

		2) 
		echo -e "${c}Installing Python2 and iPython"; $r
		sudo apt install -y python-pip
		( set -x ; pip --version )
		sudo pip install ipython
		;;

		3) 
		echo -e "${c}Installing Python3"; $r
		( set -x ; sudo add-apt-repository ppa:deadsnakes/ppa -y )
		sudo apt install -y python3
		( set -x ; python3 --version )
		;;

		4)
		installGo 
		;;

		5)
		echo -e "${c}Android Studio"; $r
    	sudo add-apt-repository ppa:maarten-fonville/android-studio
		sudo apt-get install -y android-studio 
		;;

		6) 
		echo -e "${c}Setting up Amazon Corretto (OpenJDK)"; $r
		wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
		echo "deb https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
		( set -x ; java -version )
		echo -e "${c}Amazon Corretto Installed Successfully!"; $r
		;;
		 
		7) 
		echo -e "${c}Installing Chrome"; $r
		cd
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo dpkg -i google-chrome-stable_current_amd64.deb
		sudo apt --fix-broken install -y
		rm -f google-chrome-stable_current_amd64.deb
		;;
 
		8) 
		echo -e "${c}Installing JADX (Java Decompiler)"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/skylot/jadx.git
		cd jadx
		./gradlew dist
		echo -e "${c}JADX Installed Successfully."; $r
		;;

		9) 
		echo -e "${c}Installing httprobe"; $r
		checkGo
		go get -u github.com/tomnomnom/httprobe
		;;

		10) 
		echo -e "${c}Downloading SQLMAP"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
		echo -e "${c}SQLMAP Downloaded Successfully. Go to $HOME/tools/sqlmap-dev to run it."; $r
		;;

		11) 
		echo -e "${c}Installing i3 Window Manager"; $r
		sudo apt install -y i3
		;;
 
		12) 
		echo -e "${c}Installing NodeJS"; $r
		cd
		curl -sL https://deb.nodesource.com/setup_12.x | sudo bash - #Submit the version according to your need.
		sudo apt install -y nodejs
		( set -x; nodejs -v )
		echo -e "${c}NodeJS Installed Successfully."; $r
		;;

		13) 
		echo -e "${c}Installing Wireshark"; $r
		sudo apt install -y wireshark
		sudo dpkg-reconfigure wireshark-common 
		echo -e "${c}Adding user to wireshark group."; $r
		sudo usermod -aG wireshark $USER
		echo -e "${c}Wireshark Installed Successfully."; $r
		;;

		14)
		echo -e "${c}Installing Knockpy in $HOME/tools"; $r
		cd && cd tools
		sudo apt install -y python-dnspython
		git clone --depth 1 https://github.com/guelfoweb/knock.git
		cd knock
		sudo python setup.py install
		echo -e "${c}Knockpy Installed Successfully."; $r
		;;

		15)
 		echo -e "${c}Downloading Dirsearch in $HOME/tools"; $r
 		cd && cd tools
 		git clone --depth 1 https://github.com/maurosoria/dirsearch.git
 		echo -e "${c}Dirsearch Downloaded."; $r
 		;;

 		16)
		echo -e "${c}Installing LinkFinder in $HOME/tools"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git
		cd LinkFinder
		sudo pip install argparse jsbeautifier
		sudo python setup.py install
		echo -e "${c}LinkFinder Installed Successfully."; $r
		;;

		17)
		echo -e "${c}Installing VirtualBox"; $r
		sudo apt install -y virtualbox
		;;	    

		18)
		echo -e "${c}Installing NVM"; $r
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
    nvm install --lts
    nvm use --lts
		;;	   

		19)
		echo -e "${c}Installing YARN"; $r
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
		sudo apt-get update && sudo apt-get install yarn -y
		;;	   

		20)
		echo -e "${c}Installing Java"; $r
		sudo apt-get update && sudo apt-get upgrade  
		sudo apt-get install software-properties-common -y
		sudo add-apt-repository ppa:linuxuprising/java
		sudo apt update
		sudo apt install oracle-java11-installer -y
		;;	 

		21)
		echo -e "${c}Installing MySql"; $r
		sudo apt-get install mysql-client -y
		;;	

		22)
		echo -e "${c}Installing Docker"; $r
		sudo apt update
		sudo apt install apt-transport-https ca-certificates curl software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
		sudo apt update
		apt-cache policy docker-ce
		sudo apt install docker-ce
		sudo systemctl status docker
		sudo usermod -aG docker ${USER}
		su - ${USER}
		id -nG
		echo "sudo usermod -aG docker nome-do-usuário"
		echo "docker run hello-world"
		;;	

		23)
		echo -e "${c}Installing Docker Compose"; $r
		sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
		docker-compose --version
		echo "docker-compose up -d"
		;;	

		24)
		echo -e "${c}Telegram"; $r
		sudo add-apt-repository ppa:atareao/telegram
		sudo apt-get update
		sudo apt-get install telegram
		;;	

		25)
		echo -e "${c}Steam"; $r
		sudo apt-get install steam-installer -y
		;;	
		
		26)
		echo -e "${c}VLC"; $r
		sudo apt install vlc -y
		;;	
	esac
done

# Final Upgrade and Update Command
echo -e "${c}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y