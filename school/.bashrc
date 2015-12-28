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

PATH=$PATH:~/usr/local/bin

# }}}
# Color{{{

# 256 color support
if [ -n "$DISPLAY" -a "$TERM" == "xterm"  ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen"  ]; then
    export TERM=screen-256color
fi
# enable color support of various listing commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color'
    alias grep='grep --color'
fi

LS_COLORS='*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:'
export LS_COLORS

# }}}
# Bash Prompt {{{

# BASH COLORS
# Ensures no weird invisible colors
BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
RESET='\[\033[0m\]'
BWHITE='\[\033[1;37m\]'
WHITE='\[\033[0;37m\]'
TPUTWHITE=$(tput setaf 7)
TPUTGREEN=$(tput setaf 2)
TPUTRED=$(tput setaf 1)
TPUTNORMAL=$(tput sgr0)

# Generates the git prompt
function GitPrompt {
    if [[ ! $(git status 2>&1) =~ "fatal" ]]; then
        echo " ($(GitBranch) $(GitUpToDate))"
    fi
}

# Acquires the current working branch in a repo
function GitBranch {
    echo "$(git branch | grep '* ' | cut -c3-)" # Extracts current git branch using grep and regexes
}

# If the local git repo is up to date with online one
function GitUpToDate {
    status=$(git status)
    if [[ $status =~ "Changes to be committed" ]]; then
        # There is something that needs to be committed
        echo -ne "\u2718" # Cross
    else
        # There is nothing that needs to be commited
        echo -ne "\u2714" # Check
    fi
    if [[ $status =~ "Untracked" ]]; then
        echo -ne " +"
    fi
    if [[ $status =~ "Changes not staged for commit" ]]; then
        # There is something that needs to be added
        echo -ne " \u0394" # Delta
    fi
    if [[ $status =~ "Your branch is ahead of" ]]; then
        # Local repo is ahead of online repo
        num_ahead=$(git status -sb | sed 's|[^0-9]*\([0-9\.]*\)|\1|g')
        if [[ $num_ahead == 1 ]]; then echo " | Ahead by 1 commit"; else echo " | Ahead by $num_ahead commits"; fi
    fi

    echo -ne "\n"
}

# Get the exit code
function ExitCode {
    status=$?
}

# Changes the sign of the user based on various conditions
function Sign {
    if [[ $UID == 0 ]]; then
        echo " #"
    else
	# The sign changes based on whether or not the user inputted a valid command
        if [[ $status == 0 ]]; then
            echo "${TPUTGREEN} :)${TPUTNORMAL}"
        else
            echo "${TPUTRED} :(${TPUTNORMAL}"
        fi
    fi
}

# Shows the current time
function Time {
    if [[ $showTime != true ]]; then
        return
    fi
    date=$(date "+%I:%M")
    echo "[$date]"
}

# Alters the display of the user
function User {
    if [[ $showUsername == true ]]; then
        echo -n "James"
    fi
    if [[ $showHostname == true ]]; then
        echo -n "@$(hostname)"
    fi
}

# Shows the present working directory
function Pwd {
    if [[ $shortenPath == true ]]; then
        echo -n "$PWD" | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g" # (.) holds the first letter and \1 recalls it
    else
        echo -n "$PWD" | sed -r "s|$HOME|~|g"
    fi
}

# Store last exit status code before generating a prompt
status=0

PROMPT_COMMAND="ExitCode"

prompt1="${BGREEN}\$(Time) ${BWHITE}\$(User) ${BBLUE}[\$(Pwd)]${BGREEN}\$(GitPrompt)${BWHITE}\$(Sign) \n>> "
PS1=$prompt1

# Configuration options
showTime=true
shortenPath=false
showHostname=true
showUsername=true

# Configuration aliases
alias timeon="export showTime=true"
alias timeoff="export showTime=false"
alias shorton="export shortenPath=true"
alias shortoff="export shortenPath=false"
alias hoston="export showHostname=true"
alias hostoff="export showHostname=false"

# }}}
# Functions {{{

function reminder {
    PS1="$PS1$WHITE(Reminder: " # Add space to PS1, change text color
    for word in "$@"
    do
        PS1="$PS1$word "
    done
    PS1="${PS1:0:$[${#PS1}-1]})$BWHITE "
    echo "Reminder set: $@"
}

# }}}
# Aliases {{{

# file manipulation aliases
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'

alias reload='source ~/.bashrc'

alias pico='ssh pico49524@shell2014.picoctf.com'

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
