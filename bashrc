# General Settings {{{

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

# }}}
# Color {{{

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


# Acquires the current working branch in a repo
function GitBranch {
    if [[ ! $(git status 2>&1) =~ "fatal" ]]; then
        echo " ($(git branch | grep '*' | grep -o '[^* ]*') $(GitUpToDate))" # Extracts current git branch using grep and regexes
    fi
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
    if [[ $status =~ "Changes not staged for commit" ]]; then
        # There is something that needs to be added
        echo -ne " \u0394" # Delta
    fi

    echo -ne "\n"
}

function ExitCode {
    status=$?
}

# Changes the sign of the user based on various conditions
function Sign {
    if [[ $UID == 0 ]]; then
        echo "$(tput bold)$(tput setaf 9) #$(tput sgr0)"
    else
	# The sign changes based on whether or not the user inputted a valid command
        if [[ $status == 0 ]]; then
            echo " :)"
        else
            echo " :("
        fi
    fi
}

# Shows the current time
function Time() {
    if [[ $showTime != true ]]; then
        return
    fi
    date=$(date "+%I:%M")
    echo "[$date]"
}

# Shows the current period
function Period() {
    if [[ $showPeriod != true ]]; then
        return
    fi
    period=$(python /home/james/Dev/Schedule/schedule.py )
    echo " [$period]"
}

# Shows the end of the current period
function EndPeriod() {
    if [[ $showEnd != true ]]; then
        return
    fi
    end=$(python /home/james/Dev/Schedule/endtimes.py )
    echo " [$end]"
}

# Alters the display of the user
function User() {
    if [[ $showUsername == true ]]; then
        echo -n "James"
    if [[ $showHostname == true ]]; then
        echo -n "@$(hostname)"
    fi
        if [[ $showTeam == true ]]; then
            echo -n "@Team694"
        fi
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

prompt1="${BGREEN}\$(Time)\$(Period)\$(EndPeriod) ${BRED}\$(User)${BRED}\$(Pulse)${BBLUE} [\$(Pwd)${BBLUE}]${BGREEN}\$(GitBranch)${BWHITE}\$(Sign) >> "
PS1=$prompt1

# Configuration options
showTime=true
shortenPath=false
showHostname=false
showTeam=true
showUsername=true
showPulse=true
showPeriod=true
showEnd=true

# Configuration aliases
alias timeon="export showTime=true"
alias timeoff="export showTime=false"
alias shorton="export shortenPath=true"
alias shortoff="export shortenPath=false"
alias pulseon="export showPulse=true"
alias pulseoff="export showPulse=false"
alias teamon="export showTeam=true"
alias teamoff="export showTeam=false"
alias hoston="export showHostname=true"
alias hostoff="export showHostname=false"
alias periodon="export showPeriod=true"
alias periodoff="export showPeriod=false"
alias endon="export showEnd=true"
alias endoff="export showEnd=false"
alias useron="export showUsername=true"
alias useroff="export showUsername=false"
alias short="timeoff; shorton; pulseoff; teamoff; useroff; endoff; periodoff"
alias default="timeon; shortoff; hostoff; teamon; useron; pulseon; periodon; endon"

# }}}
# Functions {{{

# Go back to your previous directory (not the same as cd ..)
function back {
    eval cd $(echo $OLDPWD | sed -r 's/[ ]+/\\ /g')
}

# Compile a cpp file with opencv because lazy
function cppcompile {
    if [[ "$#" != "2" ]]; then
        echo "Usage: cppcompile [cpp file] [name]"
    else
        eval g++ $1 -o $2 `pkg-config --libs opencv --cflags`
    fi
}

# Extracts any compressed file
function extract {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjf $1		;;
			*.tar.gz)	tar xzf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		rar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xf $1		;;
			*.tbz2)		tar xjf $1		;;
			*.tgz)		tar xzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1	;;
			*)		echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
        echo "'$1' is not a valid file"
    fi
}

# Handy reminder that reminds user about a task
function reminder {
    PS1="$PS1\[$(tput setaf 7)\](Reminder: " # Add space to PS1, change text color
    for word in "$@"
    do
        PS1="$PS1$word "
    done
    PS1="${PS1:0:$[${#PS1}-1]})\[$(tput sgr0)\] "
    echo "Reminder set: $@"
}

# Unzips a file and removes it
function ziprm {
	if [ -f $1 ] ; then
		unzip $1
		rm $1
	else
		echo "Need a valid zipfile"
	fi
}

function imbored {
    echo "fortune"
    echo "cowsay"
    echo "sl"
    echo "asciiquarium"
    echo "espeak"
    echo "starwars"
    echo "rig"
    echo "sudo woodo"
}

# }}}
# Aliases {{{

# file manipulation aliases
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'

# movement aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# admin aliases
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias root='sudo su'
alias reload='source ~/.bashrc'
alias ibrokesudo='pkexec visudo'

# git aliases
alias pulse-cv='git clone https://github.com/team694/pulse-cv'
alias wallflower='git clone https://github.com/team694/wallflower'

# ssh aliases
alias cslab='ssh james.wang@149.89.151.101'

# stuff
alias aptproxyget='sh ~/.aptproxyget/apt-proxy-get.sh'

# telnet
alias starwars='telnet towel.blinkenlights.nl'
alias excuse='telnet towel.blinkenlights.nl 666'
alias telehack='telnet telehack.com '
alias chess='telnet freechess.org'

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
