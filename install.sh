#!/bin/bash

set -e # Abort if any command exits with non-zero exit code

sudo apt-get update
sudo apt-get upgrade
sudo -v

sudo apt-get remove --purge thunderbird -y
sudo apt-get install -y indicator-cpufreq lm-sensors
sudo -v

sudo apt-get install -y openjdk-7-jdk git python-dev python3
sudo apt-get install -y python-software-properties software-properties-common python-pip
sudo apt-get install -y make gparted curl
sudo apt-get install -y unity-tweak-tool
sudo apt-get install -y silversearcher-ag

sudo -v

sudo pip install Flask BeautifulSoup4 Pillow
sudo -v

sudo apt-get autoclean -y
sudo apt-get autoremove -y
sudo -v

# zsh + tmux <3
sudo apt-get install -y zsh tmux
sudo -v

sudo apt-get install ranger

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
echo -n "Using classic menu? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-add-repository ppa:diesch/testing
    sudo apt-get update
    sudo apt-get install classicmenu-indicator
    sudo -v
fi

echo -n "Setup ssh tools? [y/n]"
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y openssh-server sshuttle
    sudo -v
fi

echo -n "Using urxvt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install rxvt-unicode-256color
    sudo -v
fi

echo -n "Using mutt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install mutt
    sudo -v
fi

echo -n "Custom font? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    wget "https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf"
    mv Droid\ Sans\ Mono\ for\ Powerline.otf $font_dir

    if command -v fc-cache @>/dev/null ; then
        echo -n "Resetting font cache, this may take a moment..."
        fc-cache -f "$font_dir"
    fi
fi

echo -n "Using vim? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
    sudo apt-get -y build-dep vim-gnome
    sudo apt-get -y install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
    if [[ ! -d /usr/include/lua5.1/include ]]; then
        sudo mkdir -p /usr/include/lua5.1/include
        sudo mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/
    fi
    if [[ ! -f /usr/bin/luajit ]]; then
        sudo ln -s /usr/bin/luajit-2.0.0-beta9 /usr/bin/luajit
    fi
    cd "$HOME"
    git clone https://github.com/vim/vim "$HOME/vim"
    cd vim/src
    ./configure --with-features=huge \
        --enable-rubyinterp \
        --enable-largefile \
        --disable-netbeans \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-perlinterp \
        --enable-luainterp \
        --with-luajit \
        --enable-gui=auto \
        --enable-fail-if-missing \
        --with-lua-prefix=/usr/include/lua5.1 \
        --enable-cscope
    make
    sudo make install
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
    sh ./install.sh
    rm install.sh
    sudo -v
fi

echo -n "Using neovim? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip ninja-build xclip
    git clone https://github.com/neovim/neovim ~/neovim
    cd ~/neovim
    sudo cp /usr/bin/ninja /usr/sbin/ninja
    make clean
    make CMAKE_BUILD_TYPE=Release # Optimized build
    sudo make install
    sudo pip install neovim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s ~/.vim $XDG_CONFIG_HOME/nvim
    ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
    sudo -v
fi

echo -n "Using i3? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y i3 i3status
    sudo -v
fi

# Misc stuff
sudo apt-get install -y sl fortune-mod espeak cowsay
sudo -v

# CTF tools
sudo apt-get install -y gimp bless binwalk audacity
sudo pip install xortool

chsh -s /bin/zsh

sudo -k
