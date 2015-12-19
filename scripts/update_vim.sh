#!/bin/bash

function build_vim() {
    cd "$HOME/vim/src"
    make distclean
    ./configure --with-features=huge \
        --enable-rubyinterp \
        --enable-largefile \
        --enable-netbeans \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-perlinterp \
        --enable-luainterp \
        --with-luajit \
        --enable-gui=gtk2 \
        --enable-fail-if-missing \
        --with-lua-prefix=/usr/include/lua5.1 \
        --enable-cscope
    make
    sudo make install
}

function update_vim() {
    first_clone=0
    # If the vim repo doesn't exist, then clone it
    if [[ ! -d "$HOME/vim" ]]; then
        sudo apt-get -y remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
        sudo apt-get -y build-dep vim-gnome
        sudo apt-get -y install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
        sudo mkdir /usr/include/lua5.1/include
        sudo mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/
        sudo ln -s /usr/bin/luajit-2.0.0-beta9 /usr/bin/luajit
        git clone https://github.com/vim/vim "$HOME/vim"
    fi
    cd "$HOME/vim/src"
    git fetch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "@{u}")

    # If local matches remote, and this isn't the first time cloning, then vim is up to date
    if [[ "$LOCAL" == "$REMOTE" && $first_clone == 0 ]]; then
        echo "Vim is up to date"
        return
    else
        # Local repo needs to be updated and vim needs to be rebuilt
        git merge origin/master
        build_vim
    fi
    version=$(vim --version | grep Vi\ IMproved)
    patches=$(vim --version | grep patches)
    echo "Vim is now updated"
    echo "$version"
    echo "$patches"
}

set -e # Abort if any command exits with non-zero exit code

# Build override
if [[ "$1" == "--build" ]]; then
    build_vim
    exit 0
fi

update_vim
