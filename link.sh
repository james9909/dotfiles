#!/bin/bash

BACKUP="$HOME/backup"

YELLOW="\E[1;33m"
GREEN="\E[1;32m"
RED="\E[1;31m"
RESET="\E[m"

function run_with_status() {
    "$@" &> /dev/null
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "${RED}Error with $@${RESET}" >&2
    else
        echo -e "${GREEN}Successfully ran $@${RESET}"
    fi
}

function link_file() {
    if [[ -f "$1" || -d "$1" ]]; then
        if [[ -d "$HOME/$1" ]]; then
            rm -r "$HOME/$1"
        fi
        if [[ -e "$HOME/$1" ]]; then
            echo -e "${YELLOW}Backing up $HOME/$1...${RESET}"
            run_with_status mv "$HOME/$1" "$BACKUP/"
        fi
        echo -e "${YELLOW}Creating symlink: $PWD/$1 -> $HOME/$1"
        run_with_status ln -s "$PWD/$1" "$HOME/$1"
    else
        echo -e "${RED}Not a valid file!${RESET}"
    fi
}

if [[ ! "$PWD" =~ .*dotfiles ]]; then
    echo -e "${RED}Please run this script from the root dotfiles directory"
    exit 1
fi

if [[ ! -d "$BACKUP" ]]; then
    mkdir -p "$BACKUP"
fi

if [[ $# != 0 ]]; then
    # Link files listed as args
    for file in "$@"; do
        link_file "$file"
    done
else
    while :; do
        ls -a
        echo -n "What file/folder would you like to link? >> "
        read file
        link_file "$file"
    done
fi
