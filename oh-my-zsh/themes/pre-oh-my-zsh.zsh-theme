#!/usr/bin/env zsh
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
export PATH="/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/games"
export EDITOR="vim"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt COMPLETE_IN_WORD
setopt ZLE
setopt VI
unsetopt EQUALS
unsetopt correct_all
unsetopt correct

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

ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"

. /etc/zsh_command_not_found
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

    RPROMPT='%{$GIT_PROMPT_INFO%}$(git_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status)'
    RPS1="${RPROMPT}"
}

if [[ "$TERM" =~ "256color" ]]; then
    is256ColorTerm=true
else
    is256ColorTerm=false
fi

prompt1="$(tput bold)$(Time)$(Period)$(EndPeriod) $(User)$(Pulse) $(Pwd)$(Sign)
{%F{white}%}>> "
PS1=$prompt1

# {{{ Git Prompt

PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]

RPROMPT='%{$GIT_PROMPT_INFO%}$(git_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status)'

RPS1="${RPROMPT}"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
# }}}

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
alias hoston="export showHostname=true"
alias hostoff="export showHostname=false"

# }}}
# Functions {{{
# Go back to your previous directory (not the same as cd ..)
function back {
    cd -
}
# Compile a cpp file with opencv because lazy
function cppcompile {
    if [[ "$#" != "2" ]]; then
        echo "Usage: cppcompile [cpp file] [name]"
    else
        eval g++ $1 -o $2 `pkg-config --libs opencv --cflags` -O2 # For some of that optimization
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

# Build the latest version of vim
function updatevim {
    version=$(vim --version | grep Vi\ IMproved)
    patches=$(vim --version | grep patches)
    currDir=$(pwd)
    # If the vim repo doesn't exist, then clone it
    if [[ ! -d "$HOME/vim" ]]; then
        cd $HOME
        git clone https://github.com/vim/vim $HOME/vim
        echo "Cloned vim"
        cd vim
        ./configure --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-cscope --enable-gui=auto --enable-gtk2-check --enable-gnome-check --with-features=huge --enable-multibyte --with-x --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-luainterp --with-luajit
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
            ./configure --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-cscope --enable-gui=auto --enable-gtk2-check --enable-gnome-check --with-features=huge --enable-multibyte --with-x --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-luainterp --with-luajit
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
# Complete words from tmux pane(s) {{{
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  # capture current pane first
  w=( ${(u)=$(tmux capture-pane -J -p)} )
  for i in $(tmux list-panes -F '#P'); do
    # skip current pane (handled above)
    [[ "$TMUX_PANE" = "$i" ]] && continue
    w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
  done
  _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^X' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
# }}}
# Aliases {{{

alias zshreload="source ~/.zshrc"
alias news="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/news.pls" # MPR News
alias current="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/the_current.pls" # The Current
alias classical="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/classical.pls" # Classical MPR
alias localcurrent="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/local.pls" # Local Current
alias sleepbot="mplayer -playlist http://sleepbot.com/ambience/cgi/listen.cgi/listen.pls" # Sleepbot Environmental Broadcast 56K MP3
alias groovesalad="mplayer -playlist http://somafm.com/groovesalad130.pls" # Soma FM Groove Salad iTunes AAC 128K
alias check-space='du -h ~/ | grep "^[0-9]*.[0-9]G"'
eval $(thefuck --alias) # Use thefuck

# import aliases from bash
if [[ -e $HOME/.bash_aliases ]]; then
    . $HOME/.bash_aliases
fi
# import zsh-specific aliases
if [[ -e $HOME/.zsh_aliases ]]; then
    . $HOME/.zsh_aliases
fi
# }}}
