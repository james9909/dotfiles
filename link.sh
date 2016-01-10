#!/bin/bash

BACKUP="$HOME/backup"

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

if [[ ! "$PWD" =~ .*dotfiles ]]; then
    echo -e "${RED}Please run this script from the root dotfiles directory"
    exit 1
fi

if [[ ! -d "$BACKUP" ]]; then
    mkdir -p "$BACKUP"
fi

while :; do
    ls -a
    echo -n "What file/folder would you like to link? >> "
    read file
    if [[ -f "$file" || -d "$file" ]]; then
        if [[ -f "$HOME/$file" ]]; then
            echo -e "${YELLOW}Backing up $HOME/$file...${RESET}"
            run_with_status mv "$HOME/$file" "$BACKUP/"
        fi
        echo -e "${YELLOW}Creating symlink: $PWD/$file -> $HOME/$file"
        run_with_status ln -s "$PWD/$file" "$HOME/$file"
    else
        echo -e "${RED}Not a valid file!${RESET}"
    fi
done
