#!/bin/bash

dir=~/Dev/dotfiles # Change with path to repo
backup=~/backup # For backup
files=".vimrc .zshrc .oh-my-zsh .tmux.conf scripts" # list of files/folders to symlink
                                        # Do not recommend syncing vim folder due to plugins being submodules,
                                        # unless --recursive was called during the clone
YELLOW="\E[1;33m"
GREEN="\E[1;32m"
RED="\E[1;31m"
RESET="\E[m"

function run_with_status {
    "$@" &> /dev/null
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "${RED}Error with $@${RESET}" >&2
    else
        echo -e "${GREEN}Successfully ran $@${RESET}"
    fi
}

# create dotfiles_old in homedir
echo -e "${YELLOW}Creating $backup for backup of any existing dotfiles in ~"
run_with_status mkdir -p $backup

# change to the dotfiles directory
echo -e "\n${YELLOW}Changing to the $dir directory"
run_with_status cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory
echo -e "\n${YELLOW}Moving any existing dotfiles from ~ to $backup"
for file in $files; do
    run_with_status mv ~/$file $backup/
done

# Create symlinks
for file in $files; do
    echo -e "\n${YELLOW}Creating symlink: ~/$file -> $dir/$file"
    run_with_status ln -s $dir/$file ~/$file
done
