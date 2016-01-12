Dotfiles
===========

These are my dotfiles. There are many like them, but these are mine.

Installation
--------------
If you only want to use some of my dotfiles, modify `link.sh` to link files that you want.
Otherwise, if you want to install everything, run `install.sh`.

#### Vim

Although [vim-plug](https://github.com/junegunn/vim-plug) is in `.vim/autoload`, cloning this repository wihout
`--recursive` will leave in a bunch of empty folders in `.vim/bundle`. Remove those folders, and run
`:PlugInstall` to install the plugins.

##### javacomplete2

If you want to install [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2), (since [javacomplete](http://www.vim.org/scripts/script.php?script_id=1785) is outdated), you need jdk8 and maven.

```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer maven
$ mvn -f ~/.vim/bundle/vim-javacomplete2/libs/javavi/pom.xml compile
```
##### eclim

[Eclim](http://eclim.org/) is a tool that essentially integrates [Eclipse](https://eclipse.org/)
functionality within Vim, and can also allow gVim to be embedded within Eclipse.
Installing eclim is as simple as running:

```
$ wget -O "eclim_2.5.0.jar" "http://sourceforge.net/projects/eclim/files/eclim/2.5.0/eclim_2.5.0.jar/download"
$ java -Dvim.files=/path/to/.vim -Declipse.home=/path/to/eclipse -jar eclim_2.5.0.jar install
```
If you wish to be able to use gVim within Eclipse, make sure that gVim has the `+netbeans_intg` flag.
Follow the guide [here](http://eclim.org/eclimd.html#gvim-embedded) for more instructions.

#### Terminal

These dotfiles are meant to be used with either `gnome-terminal` or `urxvt`.
The font used is `Droid Sans Mono for Powerline Regular`.

If you are using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), make sure
to clone the [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) repository into `~/.oh-my-zsh/custom/plugins`.

`$ git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
