# General Settings {{{

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Control the history file
HISTCONTROL=ignoreboth
HISTCONTROL=ignoredups
# Append to the history file
shopt -s histappend

# Set history size
HISTSIZE=5000
HISTFILESIZE=5000

# Makes navigating through files easier
bind TAB:menu-complete

# Auto update the values of LINES and COLUMNS.
shopt -s checkwinsize

export EDITOR=vim

export FZF_DEFAULT_COMMAND='ag -i --nocolor --nogroup --hidden --ignore .git --ignore .DS_Store --ignore "**/*.pyc" --ignore "**/*.class" --ignore _backup --ignore _undo --ignore _swap --ignore .cache -g ""'

# }}}
# Bash Prompt {{{

# ANSI Escape Codes
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[m"

function GitPrompt() {
    if [[ ! $(git status 2>&1) =~ fatal ]]; then
        echo " ($(GitBranch) $(GitUpToDate))$(GitStatus) "
    fi
}

function GitBranch() {
    git branch | grep '\* ' | cut -c3-
}

function GitUpToDate() {
    status=$(git status)
    if [[ $status =~ .*Changes\ to\ be\ committed.* ]]; then
        echo -ne "\u2718"
    else
        echo -ne "\u2714"
    fi
}

function GitStatus() {
    status=$(git status)
    if [[ $status =~ Untracked ]]; then
        echo -ne "+"
    fi
    if [[ $status =~ .*not\ staged.* ]]; then
        echo -ne "\u0394"
    fi
    if [[ $status =~ .*ahead.* ]]; then
        echo -ne "↑"
    fi
}

# Get the exit code
function ExitCode() {
    status=$?
}

# Changes the sign of the user based on various conditions
function Sign() {
    if [[ $UID == 0 ]]; then
        echo " #"
    else
    # The sign changes based on whether or not the user inputted a valid command
        if [[ $status == 0 ]]; then
            printf "${GREEN} :)${RESET}"
        else
            printf "${RED} :(${RESET}"
        fi
    fi
}

# Shows the current time
function Time() {
    date=$(date "+%I:%M")
    echo "$date"
}

# Alters the display of the user
function User() {
    echo -n "${USER}"
    if [[ $showHostname == true ]]; then
        echo -n "@$(hostname)"
    fi
}

# Appends a pulse to the user name
function Pulse() {
    if [[ $showPulse == true ]]; then
        echo "[~^v~]"
    fi
}

# Shows the present working directory
function Pwd() {
    if [[ $shortenPath == true ]]; then
        echo -n "$PWD" | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g" # (.) holds the first letter and \1 recalls it
    else
        echo -n "$PWD" | sed -r "s|$HOME|~|g"
    fi
}

# Store last exit status code before generating a prompt
status=0

PROMPT_COMMAND="ExitCode"

prompt1="${GREEN}[\$(Time)] ${RED}\$(User)${RED}\$(Pulse)${BLUE} [\$(Pwd)${BLUE}]${GREEN}\$(GitPrompt)${WHITE}\$(Sign) \n>> "
PS1=$prompt1

# Configuration options
shortenPath=false
showHostname=false
showPulse=true

# Configuration aliases
alias shorton="export shortenPath=true"
alias shortoff="export shortenPath=false"
alias pulseon="export showPulse=true"
alias pulseoff="export showPulse=false"
alias hoston="export showHostname=true"
alias hostoff="export showHostname=false"

# }}}
# Aliases {{{

# file manipulation aliases
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'

alias reload='source ~/.bashrc'
alias ibrokesudo='pkexec visudo'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# }}}
# Bash completion {{{
# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# }}}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
