function update_vim() {
    first_clone=0
    curr_dir=$(pwd)

    # Install ncurses and vim if nonexistant
    if [[ ! -d "$HOME/vim" ]]; then
        cd ~
        curl -O https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz
        mkdir ~/usr/local
        tar xzvf ncurses-6.0.tar.gz
        cd ncurses-6.0
        ./configure --prefix=$HOME/usr/local
        make
        make install
        rm -rf ncurses-6.0
        git clone https://github.com/vim/vim
        first_clone=1
        echo "Cloned vim"
    fi

    cd ~/vim/src
    git merge origin/master
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ $LOCAL = $REMOTE -a $first_clone = 0 ]; then
        echo "Vim is up to date"
        cd $curr_dir
        return
    else
        git pull
        make distclean
        LDFLAGS=-L$HOME/usr/local/lib ./configure  --prefix=$HOME/usr/local
        make
        make install
    fi
    version=$(vim --version | grep Vi\ IMproved)
    patches=$(vim --version | grep patches)
    echo "Vim is now updated"
    echo $version
    echo $patches
    cd $curr_dir
}

set -e # Abort if any command exits with non-zero exit code
update_vim
