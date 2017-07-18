#!/bin/bash

set -e # Abort if any command exits with non-zero exit code

if [[ ! $(pwd) =~ .*dotfiles ]]; then
    echo "Please run from the root directory of the repository"
fi
dotfiles=$(pwd)

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
sudo apt-get install -y mpd ncmpcpp irssi
sudo apt-get install -y wicd-curses

sudo -v

sudo pip install Flask Pillow
sudo pip install gcalcli vobject parsedatetime virtualenvwrapper
sudo -v

sudo apt-get autoclean -y
sudo apt-get autoremove -y
sudo -v

# Disable search suggestions
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope', 'reference.scope', 'reference-dictionary.scope', 'reference-wikipedia.scope']"
gsettings set com.canonical.Unity.Lenses remote-content-search none
gsettings set com.canonical.Unity.Dash scopes "['home.scope', 'applications.scope', 'files.scope']"
gsettings set com.canonical.Unity.Lenses always-search "['applications.scope']"

# Remove all useless scopes/lenses
# Not required for disabling web results
sudo apt-get remove $(dpkg --get-selections | cut -f1 | grep -P "^unity-(lens|scope)-" | grep -vP "unity-(lens|scope)-(home|applications|files)" | tr "\n" " ");

# zsh + tmux <3
sudo apt-get install -y zsh tmux
sudo -v

if [[ ! -d $HOME/.oh-my-zsh ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    ./link.sh "oh-my-zsh.zsh-theme"
fi

sudo apt-get install -y ranger

# youtube-dl
sudo apt-get install -y libav-tools id3v2
sudo curl https://yt-dl.org/downloads/2015.09.03/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo -v

# update wget
if [[ $(wget --version | grep "1.15") ]]; then
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
fi

echo -n "Setup ssh tools? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y openssh-server sshuttle
    sudo -v
fi

echo -n "Using urxvt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y libperl-dev
    sudo apt-get install -y rxvt-unicode-256color
    # cd /tmp
    # curl http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 > rxvt-unicode-9.22.tar.bz2
    # bzip2 -dc rxvt-unicode-9.22.tar.bz2 | tar xvf -
    # rm rxvt-unicode-9.22.tar.bz2
    # cd rxvt-unicode-9.22
    # ./configure --enable-everything
    # make && sudo make install
    curl -L http://db.tt/JjlLYd5A | sudo tar -xz -C /usr/lib/urxvt/perl/ && sudo mv /usr/lib/urxvt/perl/urxvtclip /usr/lib/urxvt/perl/clipboard
    sudo -v
fi

echo -n "Custom font for urxvt? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get install -y x11-xserver-utils
    cp .Xresources ~/.Xresources
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
    xrdb -merge ~/.Xresources
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
    sudo apt-get -y install python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
    sudo apt-get -y install npm nodejs
    sudo npm install -g npm
    sudo npm install -g instant-markdown-d
    cd "$HOME"
    git clone https://github.com/vim/vim "$HOME/vim"
    cd vim/src
    ./configure --with-features=huge \
        --enable-rubyinterp \
        --enable-largefile \
        --enable-netbeans \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-perlinterp \
        --enable-gui=auto \
        --enable-fail-if-missing \
        --enable-cscope
    make
    sudo make install
    sudo -v
fi

echo -n "Using neovim? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip ninja-build xclip python3-pip
    if [[ ! -d ~/neovim ]]; then
        git clone https://github.com/neovim/neovim ~/neovim
    fi
    cd ~/neovim
    sudo cp /usr/bin/ninja /usr/sbin/ninja
    make clean
    make CMAKE_BUILD_TYPE=Release # Optimized build
    sudo make install
    sudo pip3 install neovim
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
    sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev dunst i3status
    sudo apt-get install -y libconfuse-dev libyajl-dev libasound2-dev libiw-dev asciidoc libcap2-bin libpulse-dev libnl-genl-3-dev feh xautolock compton

    # rofi
    sudo apt-get install -y libxft-dev libxinerama-dev libpango1.0-dev

    wget -c https://github.com/DaveDavenport/rofi/releases/download/1.1.0/rofi-1.1.0.tar.gz
    tar -xzvf rofi-0.15.4.tar.gz
    cd rofi-0.15.4

    autoreconf -i
    ./configure
    make && sudo make install

    if [[ ! -d ~/i3-gaps ]]; then
        git clone https://github.com/Airblader/i3 ~/i3-gaps
    fi
    cd ~/i3-gaps
    sudo apt-get install libx11-xcb-dev
    git checkout gaps
    make
    sudo make install
    sudo -v
fi

# Screenfetch
sudo apt-get install -y lsb-release scrot
sudo wget -O /usr/bin/screenfetch "https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev"
sudo chmod +x /usr/bin/screenfetch
sudo -v

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# Misc stuff
sudo apt-get install -y sl fortune-mod espeak cowsay
sudo -v

# CTF tools
sudo apt-get install -y gimp bless binwalk audacity tshark wireshark
sudo pip install xortool
sudo -v

# Network hooks
cd "$dotfiles"
sudo cp scripts/wifi-connect /etc/network/if-up.d/wifi-connect
sudo cp scripts/wifi-disconnect /etc/network/if-down.d/wifi-disconnect

sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash intel_pstate=disable\"/" /etc/default/grub
sudo update-grub

chsh -s /bin/zsh

sudo -k

files="
.vimrc
.zshrc
.tmux.conf
.vim
.i3
.i3status.conf
.bashrc
.bash_aliases
.Xresources
.ssh/config
scripts
.irssi
.compton.conf
.gitconfig
.gitignore_global
"

./link.sh $files
