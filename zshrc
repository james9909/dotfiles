# General configuration {{{
# vim:fdm=marker

ZSH=~/.zsh

HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# User configuration
export PATH="/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl"
export EDITOR="vim"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt ZLE
setopt VI
unsetopt EQUALS

# use cache when auto-completing
zstyle ':completion::complete:*' use-cache 1
# use case-insensitive auto-completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# graphical auto-complete menu
zstyle ':completion:*' menu select

# use automatic path prediction
# $predict-on to turn on and $predict-off to turn off
autoload predict-on
autoload predict-off
# use advanced completion system
autoload -U compinit && compinit
# colors
autoload -U colors && colors

source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"
# }}}
# Color support {{{

# Force color in terminal
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
    export TERM=screen-256color
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;92:st=37;44:ex=01;04:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS

# Force color in terminal
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
    export TERM=screen-256color
fi

# }}}
# Prompt {{{

# Generates the git prompt
function GitPrompt {
    if [[ ! $(git status 2>&1) =~ "fatal" ]]; then
        echo " %{%F{green}%}($(GitBranch) $(GitUpToDate))%f%k"
    fi
}

# Acquires the current working branch in a repo
function GitBranch {
    echo "$(git branch | grep '* ' | cut -c3-)" # Extracts current git branch using grep and regexes
}

# If the local git repo is up to date with online one
function GitUpToDate {
    GitStatus=$(git status)
    if [[ $GitStatus =~ "Changes to be committed" ]]; then
        # There is something that needs to be committed
        echo -ne "\u2718" # Cross
    else
        # There is nothing that needs to be commited
        echo -ne "\u2714" # Check
    fi
    if [[ $GitStatus =~ "Untracked" ]]; then
        echo -ne " +"
    fi
    if [[ $GitStatus =~ "Changes not staged for commit" ]]; then
        # There is something that needs to be added
        echo -ne " \u0394" # Delta
    fi
    if [[ $GitStatus =~ "Your branch is ahead of" ]]; then
        # Local repo is ahead of online repo
        echo " | Ahead by $(git status -sb | sed 's|[^0-9]*\([0-9\.]*\)|\1|g')"
    fi
    if [[ $GitStatus =~ "Your branch is behind" ]]; then
        # Local repo is ahead of online repo
        echo " | Behind by $(git status -sb | sed 's|[^0-9]*\([0-9\.]*\)|\1|g')"
    fi

    echo -ne "\n"
}

# Get the exit code
function GetExitCode {
    exitCode=$?
}

# Changes the sign of the user based on various conditions
function Sign {
    if [[ $UID == 0 ]]; then
        echo " #"
    else
        # The sign changes based on whether or not the user inputted a valid command
        if [[ $exitCode == 0 ]]; then
            echo "%{%F{green}%} :)"
        else
            echo "%{%F{red}%} :("
        fi
    fi
}

# Shows the current time
function Time {
    if [[ $showTime != true ]]; then
        return
    fi
    date=$(date "+%I:%M")
    echo "%{%F{green}%}[$date]"
}

# Schedule {{{
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
# }}}

# Alters the display of the user
function User {
    if [[ $showUsername == true ]]; then
        echo -n "%{%F{red}%}James"
        if [[ $showHostname == true ]]; then
            echo -n "%{%F{red}%}@$(hostname)"
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
        DIR=$(pwd | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g") # (.) holds the first letter and \1 recalls it
        echo -n %{%F{blue}%}"[$DIR]"
    else
        DIR=$(pwd | sed -r "s|$HOME|~|g")
        echo -n %{%F{blue}%}"[$DIR]"
    fi
}

exitCode=0
#Note: the prompt function is not allowed to globally change any variable values; only the PROMPT_COMMAND / precmd() is able
setopt prompt_subst
function precmd() { # zsh equivalent of PROMPT_COMMAND in bash
    GetExitCode
    prompt1="$(tput bold)$(Time)$(Period)$(EndPeriod) $(User)$(Pulse) $(Pwd)$(Sign)
%{%F{white}%}>> "
    PS1=$prompt1
    RPROMPT="$(GitPrompt)"
}

if [[ "$TERM" =~ "256color" ]]; then
    is256ColorTerm=true
else
    is256ColorTerm=false
fi

prompt1="$(tput bold)$(Time)$(Period)$(EndPeriod) $(User)$(Pulse) $(Pwd)$(Sign)
%{%F{white}%}>> "
PS1=$prompt1
RPROMPT="$(GitPrompt)"

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
            *.7z)           7z e $1;;
            *)              echo "'$1' cannot be extracted via extract"
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Unzips a file and removes it
function ziprm {
    if [ -f $1 ] ; then
        extract $1
        rm $1
    fi
}

# Build the latest version of vim
function updatevim {
    version=$(vim --version | grep Vi\ IMproved)
    patches=$(vim --version | grep patches)
    currDir=$(pwd)
    # If the vim repo doesn't exist, then clone it
    if [[ ! -d "~/vim" ]]; then
        cd $HOME
        git clone https://github.com/vim/vim $HOME/vim
        echo "Cloned vim"
        cd vim
        ./configure --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-cscope --enable-gui=auto --enable-gtk2-check --enable-gnome-check --with-features=huge --enable-multibyte --with-x --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
        make
        sudo make install
        echo "Vim is now updated"
        echo $version
        echo $patches
        cd $currDir
        return
    else
        cd $HOME/vim
        # Local repo is up to date and we are up to date
        if [[ $(git pull) =~ "up to date" ]]; then
            echo "Vim is up to date"
            echo $version
            echo $patches
            cd $currDir
            return
            # Local repo needs to be updated and vim needs to be rebuilt
        else
            git pull
            ./configure --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-cscope --enable-gui=auto --enable-gtk2-check --enable-gnome-check --with-features=huge --enable-multibyte --with-x --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
            make
            sudo make install
            echo "Vim is now updated"
            echo $version
            echo $patches
            cd $currDir
        fi
    fi
}

# }}}
# Aliases {{{
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'

alias zshreload='source ~/.zshrc'
# import aliases from bash
if [[ -e $HOME/.bash_aliases ]]; then
    . $HOME/.bash_aliases
fi
# import zsh-specific aliases
if [[ -e $HOME/.zsh_aliases ]]; then
    . $HOME/.zsh_aliases
fi
# }}}
