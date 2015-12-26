#!/bin/bash

set -e # Abort if any command exits with non-zero exit code

sudo apt-get update
sudo apt-get upgrade
sudo -v

sudo apt-get remove -y --purge thunderbird
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

sudo apt-get install -y ranger

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
if [[ ! -d /opt/wget/WGET_REAL_1_15 ]]; then
    sudo mkdir /opt/wget/WGET_REAL_1_15
fi
sudo mv /usr/bin/wget /opt/wget/WGET_REAL_1_15/wget_1_15
if [[ ! -f /usr/bin/wget ]]; then
    sudo ln -s /opt/wget/bin/wget /usr/bin/wget
fi
sudo -v

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

echo -n "Custom font for urxvt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    font_dir="$HOME/.local/share/fonts"
    if [[ ! -d $font_dir ]]; then
        mkdir -p "$font_dir"
    fi
    wget "https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf"
    mv Droid\ Sans\ Mono\ for\ Powerline.otf $font_dir

    if command -v fc-cache @>/dev/null ; then
        echo -n "Resetting font cache, this may take a moment..."
        fc-cache -f "$font_dir"
    fi
fi

echo -n "Using mutt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install mutt
    sudo -v
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
    if [[ ! -d ~/neovim ]]; then
        git clone https://github.com/neovim/neovim ~/neovim
    fi
    cd ~/neovim
    sudo cp /usr/bin/ninja /usr/sbin/ninja
    make clean
    make CMAKE_BUILD_TYPE=Release # Optimized build
    sudo make install
    sudo pip install neovim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    if [[ ! -d $XDG_CONFIG_HOME/nvim ]]; then
        ln -s ~/.vim $XDG_CONFIG_HOME/nvim
    fi
    if [[ ! -f $XDG_CONFIG_HOME/nvim/init.vim ]]; then
        ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
    fi
    sudo -v
fi

echo -n "Using i3? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev
    sudo apt-get install -y i3status
    sudo apt-get install -y rofi
    if [[ ! -d ~/i3-gaps ]]; then
        git clone https://github.com/Airblader/i3 ~/i3-gaps
    fi
    cd ~/i3-gaps
    make
    sudo make install
    sudo -v
fi

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# Misc stuff
sudo apt-get install -y sl fortune-mod espeak cowsay
sudo -v

# CTF tools
sudo apt-get install -y gimp bless binwalk audacity
sudo pip install xortool

chsh -s /bin/zsh

sudo -k
