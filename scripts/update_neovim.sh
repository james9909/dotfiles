#!/bin/bash

function update_neovim() {
    curr_dir=$(pwd)
    first_clone=0
    # Clone and build neovim if it doesn't already exist
    if [[ ! -d "$HOME/neovim" ]]; then
        sudo apt-get -y install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip ninja
        git clone https://github.com/neovim/neovim $HOME/neovim
        echo "Cloned neovim"
        first_clone=1
    fi
    cd $HOME/neovim
    git fetch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    # Neovim is up to date
    if [ $LOCAL = $REMOTE -a $first_clone = 0 ]; then
        echo "Neovim is up to date"
    else
        # Update neovim to latest version
        git pull
        make clean
        make CMAKE_BUILD_TYPE=Release # Optimized build
        sudo make install
    fi
    echo "Neovim is now updated"
    cd $curr_dir
}

update_neovim
