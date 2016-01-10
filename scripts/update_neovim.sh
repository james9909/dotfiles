#!/bin/bash

function build_neovim() {
    cd "$HOME/neovim"
    make clean &&
    make CMAKE_BUILD_TYPE=Release # Optimized build
    sudo make install
}

function update_neovim() {
    # Check if neovim exists as a command
    if [[ $(command -v nvim) ]]; then
        cd "$HOME/neovim"
        git fetch
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse "@{u}")

        # Neovim is up to date
        if [[ "$LOCAL" == "$REMOTE" ]]; then
            echo "Neovim is up to date"
            return
        else
            # Update neovim to latest version
            git merge origin/master
            build_neovim
        fi
        echo "Neovim is now updated"
    else
        if [[ ! -d "$HOME/neovim" ]]; then
            sudo apt-get -y install cpp:i386 libtool:i386 autoconf automake cmake g++ pkg-config unzip ninja-build
            git clone https://github.com/neovim/neovim "$HOME/neovim"
        fi
        cd "$HOME/neovim"
        build_neovim
    fi
}

set -e # Abort if any command exits with non-zero exit code

# Build override
if [[ "$1" == "--build" ]]; then
    build_neovim
    exit 0
fi

update_neovim
