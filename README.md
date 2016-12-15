Dotfiles
===========

These are my dotfiles. There are many like them, but these are mine.

Installation
--------------
If you only want to use some of my dotfiles, run `link.sh` to link files that you want.
Otherwise, if you want to install everything, run `install.sh`.

Vim
---

To build the latest version of vim, run the `updatevim` script in the `scripts` folder.

To install all the plugins, just run `:PlugInstall` when opening vim for the first time.

##### javacomplete2

If you want to install [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2), (since [javacomplete](http://www.vim.org/scripts/script.php?script_id=1785) is outdated), you need jdk8 and maven.

```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer maven
$ mvn -f ~/.vim/bundle/vim-javacomplete2/libs/javavi/pom.xml compile
```

#### Terminal

These dotfiles are meant to be used with either `gnome-terminal` or `urxvt`.
The font used is `Droid Sans Mono for Powerline Regular`.
