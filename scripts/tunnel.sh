#!/bin/bash

# ANSI Escape Codes
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[m"

TUNNELS_DIR="$HOME/.sshuttle"
TUNNELS="tunnels"
TUNNELS_PATH="$TUNNELS_DIR/$TUNNELS"

pidfile="/tmp/tunnel.pid"

function add_tunnel() {
    NAME=$1
    IP=$2
    if [[ $(grep "$NAME" "$TUNNELS_PATH") != "" ]]; then
        printf "${RED}Tunnel name already taken!${RESET}\n"
        exit 1
    fi
    if [[ $(grep "$IP" "$TUNNELS_PATH") != "" ]]; then
        printf "${RED}Tunnel with that ip already taken!${RESET}\n"
        exit 1
    fi
    echo "$NAME=$IP" >> "$TUNNELS_PATH"
    printf "${GREEN}Tunnel successfully added!${RESET}\n"
}

function list_tunnels() {
    while read line; do
        IFS="=" read -r -a tunnel <<< "$line"
        NAME="${tunnel[0]}"
        IP="${tunnel[1]}"
        if [[ "$NAME" == "" || "$IP" == "" ]]; then
            continue
        else
            printf "$NAME:\n\t$IP\n"
        fi
    done < "$TUNNELS_PATH"
}

function delete_tunnel() {
    if [[ $(grep "$1" "$TUNNELS_PATH") == "" ]]; then
        printf "${RED}Tunnel doesn't exist!${RESET}\n"
        exit 1
    fi
    grep -v "$1" "$TUNNELS_PATH" > "$TUNNELS.tmp"
    mv "$TUNNELS.tmp" "$TUNNELS_PATH"
    printf "${GREEN}Tunnel $1 successfully deleted!${RESET}\n"
}

function connect() {
    tunnel=$1
    found=$(grep "$tunnel" "$TUNNELS_PATH")
    if [[ $found != "" ]]; then
        IP=$(echo "$found" | cut -d"=" -f2)
        sshuttle --pidfile "$pidfile" --daemon 0/0 -r "$IP"
    else
        sshuttle --pidfile "$pidfile" --daemon 0/0 -r "$tunnel"
    fi
}

function kill() {
    if [[ ! -f "$pidfile" ]]; then #|| $(pgrep "sshuttle") == "" ]]; then
        printf "${RED}No connection found.${RESET}\n"
        exit 1
    fi
    sudo kill "$(cat "$pidfile")"
}

function help() {
    echo -e "Usage: $0 [-a NAME IP] [-l] [-d NAME] [-c NAME] [-h]"
    echo -e "\t-a, --add NAME IP\tAdd a tunnel"
    echo -e "\t-l, --list \t\tList all tunnels"
    echo -e "\t-d, --delete \t\tRemove a tunnel"
    echo -e "\t-c, --connect \t\tConnect to a tunnel"
    echo -e "\t-h, --help \t\tDisplay this help message"
    echo -e "\t-k --kill \t\tKill current connection"
}

if [ ! -d "$TUNNELS_DIR" ]; then
    mkdir -p "$TUNNELS_DIR"
fi
if [ ! -f "$TUNNELS_PATH" ]; then
    touch "$TUNNELS_PATH"
fi

if [[ $# -gt 0 ]]; then
    if [[ $1 == "--help" || $1 == "-h" ]]; then
        help
    elif [[ $1 == "-a" || $1 == "--add" ]]; then
        if [[ $# -lt 3 ]]; then
            help
        else
            add_tunnel "$2" "$3"
        fi
    elif [[ $1 == "-l" || $1 == "--list" ]]; then
        list_tunnels
    elif [[ $1 == "-d" || $1 == "--delete" ]]; then
        if [[ $# -lt 2 ]]; then
            help
        else
            delete_tunnel "$2"
        fi
    elif [[ $1 == "-c" || $1 == "--connect" ]]; then
        if [[ $# -lt 2 ]]; then
            help
        else
            connect "$2"
        fi
    elif [[ $1 == "-k" || $1 == "--kill" ]]; then
        kill
    else
        help
    fi
else
    help
fi
