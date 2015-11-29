# Set proxies for this script
export http_proxy=filtr.nycboe.org:8002
export https_proxy=filtr.nycboe.org:8002

# Install ncurses and vim
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
cd ~/vim
LDFLAGS=-L$HOME/usr/local/lib ./configure  --prefix=$HOME/usr/local
make
make install
