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
        echo " | Ahead by $(git status -sb | sed 's|[^0-9]*\([0-9\.]*\)|\1|g') commits"
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

# Shows the current period
function Period {
    hour=$(date +%H | sed 's/^0*//') # 0 - 60 (The sed removes leading 0s)
    minute=$(date +%M | sed 's/^0*//') # 0 - 60
    day=$(date +%w) # 0 is Sunday, 6 is Saturday

    if [ "$day" -ne 0 ] && [ $day -ne 6 ]; then
        if [[ $hour -eq 8 && $minute -le 41 ]]; then
            echo " [Period 1 | "
        elif [[  $hour -eq 8 && $minute -ge 45 || $hour -eq 9 && $minute -le 26 ]]; then
            echo " [Period 2 | "
        elif [[ $hour -eq 9 && $minute -ge 31 || $hour -eq 10 && $minute -le 15 ]] ; then
            echo " [Period 3 | "
        elif [[ $hour -eq 10 && $minute -ge 20 || $hour -eq 11 && $minute -le 1 ]]; then
            echo " [Period 4 | "
        elif [[ $hour -eq 11 && $minute -ge 6 && $minute -le 47 ]]; then
            echo " [Period 5 | "
        elif [[ $hour -eq 11 && $minute -ge 52 || $hour -eq 12 && $minute -le 33 ]]; then
            echo " [Period 6 | "
        elif [[ $hour -eq 12 && $minute -ge 38 || $hour -eq 13 && $minute -le 19 ]]; then
            echo " [Period 7 | "
        elif [[ $hour -eq 13 && $minute -ge 24 || $hour -eq 14 && $minute -le 5 ]]; then
            echo " [Period 8 | "
        elif [[ $hour -eq 14 && $minute -ge 9 && $minute -le 50 ]]; then
            echo " [Period 9 | "
        elif [[ $hour -eq 14 && $minute -ge 54 || $hour -eq 15 && $minute -lt 35 ]]; then
            echo " [Period 10 | "
        else
            return
        fi
    else
        return
    fi

}

# Shows when the current period ends
function EndPeriod {
    period="$(Period)"

    if [[ $period == ' [Period 1 | ' ]]; then
        echo 'Ends at 8:41]'
    elif [[ $period == ' [Period 2 | ' ]]; then
        echo 'Ends at 9:26]'
    elif [[ $period == ' [Period 3 | ' ]]; then
        echo 'Ends at 10:15]'
    elif [[ $period == ' [Period 4 | ' ]]; then
        echo 'Ends at 11:01]'
    elif [[ $period == ' [Period 5 | ' ]]; then
        echo 'Ends at 11:47]'
    elif [[ $period == ' [Period 6 | ' ]]; then
        echo 'Ends at 12:33]'
    elif [[ $period == ' [Period 7 | ' ]]; then
        echo 'Ends at 1:19]'
    elif [[ $period == ' [Period 8 | ' ]]; then
        echo 'Ends at 2:05]'
    elif [[ $period == ' [Period 9 | ' ]]; then
        echo 'Ends at 2:50]'
    elif [[ $period == ' [Period 10 | ' ]]; then
        echo 'Ends at 3:35]'
    else
        return
    fi
}

# Alters the display of the user
function User {
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
function Pulse {
    if [[ $showPulse == true ]]; then
        echo "[~^v~]"
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

prompt1="${BGREEN}\$(Time)\$(Period)\$(EndPeriod) ${BRED}\$(User)${BRED}\$(Pulse)${BBLUE} [\$(Pwd)${BBLUE}]${BGREEN}\$(GitPrompt)${BWHITE}\$(Sign) \n>> "
PS1=$prompt1

# Configuration options
showTime=true
shortenPath=false
showHostname=false
showTeam=true
showUsername=true
showPulse=true

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
alias useron="export showUsername=true"
alias useroff="export showUsername=false"

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
        eval g++ $1 -o $2 `pkg-config --libs opencv --cflags` -O2 # For some of that optimization
    fi
}

# Copy a folder into another directory
function cpdir {
    if [[ "$#" != "2" ]]; then
        echo "Usage: cpdir [source] [destination]"
    else
        cp -arv $1 $2
    fi
}

# Extracts any compressed file
function extract {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)      tar xjf $1;;
            *tar.gz)        tar xzf $1;;
            *bz2)           bunzip2 $1;;
            *.rar)          rar x $1;;
            *.gz)           gunzip $1;;
            *.tar)          tar xf $1;;
            *.tbz2)         tar xzf $1;;
            *.tgz)          unzip $1;;
            *.zip)          unzip $1;;
            *.Z)            uncompress $1;;
            *)              echo "'$1' cannot be extracted via extract"
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Handy reminder that reminds user about a task
function reminder {
    PS1="$PS1$WHITE(Reminder: " # Add space to PS1, change text color
    for word in "$@"
    do
        PS1="$PS1$word "
    done
    PS1="${PS1:0:$[${#PS1}-1]})$BWHITE "
    echo "Reminder set: $@"
}

# Unzips a file and removes it
function ziprm {
    if [ -f $1 ] ; then
        extract $1
        rm $1
    fi
}

# boreeeddddd
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

# admin aliases
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias root='sudo su'
alias reload='source ~/.bashrc'
alias ibrokesudo='pkexec visudo'
alias bashtime='time . ~/.bashrc'
alias debugon='set -x'
alias debugoff='set +x'

# ssh aliases
alias school='ssh james.wang@149.89.151.101'

# stuff
alias aptproxyget='sh ~/.aptproxyget/apt-proxy-get.sh'

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
