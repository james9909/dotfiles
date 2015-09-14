#!/bin/bash

dir=~/Path/to/repo # Change with path to repo
backup=~/backup # For backup
files="vim vimrc zshrc oh-my-zsh tmux.conf" # list of files/folders to symlink

# create dotfiles_old in homedir
echo "Creating $backup for backup of any existing dotfiles in ~"
mkdir -p $backup
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory
echo "Moving any existing dotfiles from ~ to $backup"
for file in $files; do
    mv ~/.$file $backup/
done
mv ~/.bashrc $backup/

# Create symlinks
for file in $files; do
    echo "Creating symlink: ~/.$file -> $dir/$file"
    ln -s $dir/$file ~/.$file
done
