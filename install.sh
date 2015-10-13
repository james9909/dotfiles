#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo -v

sudo apt-get remove --purge thunderbird -y
sudo apt-get install -y indicator-cpufreq lm-sensors
sudo -v

sudo apt-get install -y openjdk-7-jdk icedtea-6-plugin git subversion python-dev python3
sudo apt-get install -y python-software-properties software-properties-common python-pip
sudo apt-get install -y make gparted curl
sudo apt-get install -y openssh-server
sudo apt-get install -y unity-tweak-tool
sudo -v

sudo pip install Flask BeautifulSoup4, lxml, Pillow
sudo -v

sudo apt-get autoclean -y
sudo apt-get autoremove -y
sudo -v

# zsh + tmux <3
sudo apt-get install -y zsh tmux
sudo -v

# youtube-dl
sudo apt-get install -y libav-tools id3v2
sudo curl https://yt-dl.org/downloads/2015.09.03/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo -v

# update wget
sudo apt-get update
sudo apt-get -y build-dep wget
cd /tmp
wget http://ftp.gnu.org/gnu/wget/wget-1.16.tar.gz
tar -xvf wget-1.16.tar.gz
cd wget-1.16/
./configure --with-ssl=openssl --prefix=/opt/wget
make
sudo -v
sudo make install
sudo mkdir /opt/wget/WGET_REAL_1_15
sudo mv /usr/bin/wget /opt/wget/WGET_REAL_1_15/wget_1_15
sudo ln -s /opt/wget/bin/wget /usr/bin/wget
sudo -v

# Classic menu
sudo apt-add-repository ppa:diesch/testing
sudo apt-get update
sudo apt-get install classicmenu-indicator
sudo -v

chsh -s /bin/zsh

# Vim <3
git clone https://github.com/james9909/dotfiles
cd dotfiles
./link.sh
cp -rfv vim ~/.vim
updatevim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sudo -v

# Misc stuff
sudo apt-get install -y sl fortune-mod espeak cowsay

sudo -k
