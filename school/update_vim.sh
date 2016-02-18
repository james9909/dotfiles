#!/bin/bash

function build_vim() {
    cd "$HOME/vim/src"
    make distclean
    LDFLAGS=-L$HOME/usr/local/lib
    ./configure --prefix="$HOME/usr/local" --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
    make
    make install
}

function update_vim() {
    if [[ $(command -v vim) ]]; then
        cd "$HOME/vim/src"
        git stash
        git fetch
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse "@{u}")

        if [[ "$LOCAL" == "$REMOTE" ]]; then
            echo "Vim is up to date"
            return
        else
            git merge origin/master
            build_vim
        fi
        version=$(vim --version | grep Vi\ IMproved)
        patches=$(vim --version | grep patches)
        echo "Vim is now updated"
        echo "$version"
        echo "$patches"
    else
        # Install ncurses and vim if nonexistant
        if [[ ! -d "$HOME/vim" ]]; then
            cd ~
            curl -O https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz
            mkdir ~/usr/local
            tar xzvf ncurses-6.0.tar.gz
            cd ncurses-6.0
            ./configure --prefix="$HOME/usr/local"
            make
            make install
            rm -rf ncurses-6.0
            git clone https://github.com/vim/vim
        fi
        cd "$HOME/vim/src"
        build_vim
    fi
}

set -e # Abort if any command exits with non-zero exit code

# Build override
if [[ "$1" == "--build" ]]; then
    build_vim
    exit 0
fi

update_vim
