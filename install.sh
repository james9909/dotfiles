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

sudo apt-get install -y openjdk-8-jdk git python-dev python3
sudo apt-get install -y software-properties-common python-pip python3-pip
sudo apt-get install -y make gparted curl
sudo apt-get install -y unity-tweak-tool
sudo apt-get install -y silversearcher-ag
sudo apt-get install -y mpd ncmpcpp irssi
sudo apt-get install -y wicd-curses

sudo apt-get -y install npm nodejs

sudo -v

pip install --user Flask Pillow virtualenvwrapper
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
mkdir -p ~/.tmux/plugins
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
pip3 install --user powerline-status
sudo -v

if [[ ! -d $HOME/.oh-my-zsh ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/marzocchi/zsh-notify.git ~/.oh-my-zsh/custom/plugins/notify
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

sudo apt-get install -y ranger

# youtube-dl
sudo apt-get install -y ffmpeg id3v2
sudo curl https://yt-dl.org/downloads/2015.09.03/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo -v

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. ~/.cargo/env
rustup override set stable
rustup update stable
cargo install clippy
cargo install rustfmt
sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
sudo cp target/release/alacritty /usr/local/bin/alacritty
cd $dotfiles

curl -O https://github.com/dandavison/delta/releases/download/0.4.1/delta-0.4.1-x86_64-unknown-linux-musl.tar.gz
tar -xzvf delta-0.4.1-x86_64-unknown-linux-musl.tar.gz
sudo cp delta-0.4.1-x86_64-unknown-linux-musl /usr/local/bin
rm -rf delta-0.4.1-x86_64-unknown-linux-musl

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
    wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf"
    mv Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf "$font_dir"

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
    sudo apt-get -y install python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev exuberant-ctags
    sudo npm install -g instant-markdown-d
    cd "$HOME"
    git clone https://github.com/vim/vim "$HOME/vim"
    cd vim/src
    ./configure --with-features=huge \
        --enable-rubyinterp \
        --enable-largefile \
        --enable-netbeans \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
        --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
        --enable-perlinterp \
        --enable-gui=auto \
        --enable-fail-if-missing \
        --enable-cscope \
        --enable-terminal
    make -j4
    sudo make install
    sudo -v
    cd $dotfiles
    ./link.sh .vim .vimrc
fi

echo -n "Using neovim? [y/n] "
read ans
if [[ $ans =~ ^[Yy]$ ]]; then
    sudo apt-get -y install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip ninja-build xclip texinfo
    if [[ ! -d ~/neovim ]]; then
        git clone https://github.com/neovim/neovim ~/neovim
    fi
    cd ~/neovim
    sudo cp /usr/bin/ninja /usr/sbin/ninja
    make clean
    make -j4 CMAKE_BUILD_TYPE=Release # Optimized build
    sudo make install
    sudo pip3 install --user neovim
    sudo pip install --user neovim
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
    sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libx11-xcb-dev libxcb-xrm-dev dunst
    sudo apt-get install -y libconfuse-dev libyajl-dev libasound2-dev libiw-dev asciidoc libcap2-bin libpulse-dev libnl-genl-3-dev feh xautolock compton

    # rofi
    sudo apt-get install -y libxft-dev libxinerama-dev libpango1.0-dev

    wget -c https://github.com/DaveDavenport/rofi/releases/download/1.1.0/rofi-1.1.0.tar.gz
    tar -xzvf rofi-1.1.0.tar.gz
    cd rofi-0.15.4

    autoreconf -i
    ./configure
    make -j4 && sudo make install

    if [[ ! -d ~/i3-gaps ]]; then
        git clone https://github.com/Airblader/i3 ~/i3-gaps
    fi
    cd ~/i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build

    # Disabling sanitizers is important for release versions!
    # The prefix and sysconfdir are, obviously, dependent on the distribution.
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make -j4
    sudo make install
    sudo -v

    sudo apt-get install -y fonts-font-awesome net-tools
    # Install polybar
    if [[ ! -d ~/polybar ]]; then
        git clone --recursive https://github.com/jaagr/polybar ~/polybar
    fi
    rm -rf ~/polybar/build
    mkdir -p ~/polybar/build
    cd ~/polybar/build
    cmake ..
    sudo make install
fi

# Neofetch
sudo apt-get install -y lsb-release scrot
cd ~ && git clone https://github.com/dylanaraps/neofetch && cd neofetch && sudo make install
sudo -v

# Misc stuff
sudo apt-get install -y sl fortune-mod espeak cowsay
sudo -v

# CTF tools
sudo apt-get install -y gimp bless binwalk audacity tshark wireshark
sudo pip install --user xortool
sudo -v

# # Network hooks
# cd "$dotfiles"
# sudo cp scripts/wifi-connect /etc/network/if-up.d/wifi-connect
# sudo cp scripts/wifi-disconnect /etc/network/if-down.d/wifi-disconnect

sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash intel_pstate=disable\"/" /etc/default/grub
sudo update-grub

chsh -s /bin/zsh

sudo -k

files="
.zshrc
.tmux.conf
.tmux.conf.local
.i3
.bashrc
.bash_aliases
.Xresources
.ssh/config
scripts
.irssi
.compton.conf
.gitconfig
.gitignore_global
.config/polybar
.config/ranger
.config/dunst
.config/powerline
.config/wal
.config/spicetify/config.ini
.config/spicetify/Themes
.config/alacritty/
.p10k.zsh
"

cd $dotfiles
./link.sh $files
