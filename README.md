Dotfiles
===========

These are my dotfiles. There are many like them, but these are mine.
Installation
--------------
For easy installation, modify `link.sh` to link files that you want, and run the script.

### Vundle

There are two ways to be able to use my `vim` folder, manually or automatically.
Unless you want a +200MB repo, do not clone recursively, because [YCM](https://github.com/Valloric/YouCompleteMe) has a ton of submodules.
If you do not care about this, use method #2. Otherwise, use method #1.

#### Method #1
Since plugins are submoduled, [Vundle](https://github.com/VundleVim/Vundle.vim) will not be cloned by default.

To install [Vundle](https://github.com/VundleVim/Vundle.vim), run:

`$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

Then you can open up `vim` and run `:PluginInstall` to install the rest of the plugins.

#### Method #2
`$ git clone --recursive https://github.com:james9909/dotfiles`

If using oh-my-zsh, make sure to clone the [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) repository into oh-my-zsh/custom/plugins

`$ git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins`

### Eclim and javacomplete2

If you want to install eclim, just follow the instructions over [here](http://eclim.org/install.html).

If you want to install [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2), (since [javacomplete](http://www.vim.org/scripts/script.php?script_id=1785) is outdated), you need jdk8 and maven.

```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
$ mvn -f ~/.vim/bundle/vim-javacomplete2/libs/javavi/pom.xml compile
```
