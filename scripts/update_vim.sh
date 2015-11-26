#!/bin/bash

# Build the latest version of vim
function update_vim() {
    curr_dir=$(pwd)
    first_clone=0
    # If the vim repo doesn't exist, then clone it
    if [[ ! -d "$HOME/vim" ]]; then
        sudo apt-get -y remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
        sudo apt-get -y build-dep vim-gnome
        sudo apt-get -y install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
        sudo mkdir /usr/include/lua5.1/include
        sudo mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/
        sudo ln -s /usr/bin/luajit-2.0.0-beta9 /usr/bin/luajit
        git clone https://github.com/vim/vim $HOME/vim
        echo "Cloned vim"
    fi
    cd $HOME/vim/src
    git fetch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ $LOCAL = $REMOTE -a $first_clone = 0 ]; then
        echo "Vim is up to date"
        return
    else
        # Local repo needs to be updated and vim needs to be rebuilt
        git pull
        make distclean
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
    fi
    version=$(vim --version | grep Vi\ IMproved)
    patches=$(vim --version | grep patches)
    echo "Vim is now updated"
    echo $version
    echo $patches
    cd $curr_dir
}

update_vim
