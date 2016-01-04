#!/usr/bin/env zsh
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
function GetExitCode() {
    exitCode=$?
}

# Changes the sign of the user based on various conditions
function Sign() {
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
function Time() {
    date=$(date "+%I:%M")
    echo "%{%F{green}%}[$date]"
}

# Alters the display of the user
function User() {
    echo -n "%{%F{red}%}$USER"
    if [[ $showHostname == true ]]; then
        echo -n "%{%F{red}%}@$(hostname)"
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
        DIR=$(pwd | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g") # (.) holds the first letter and \1 recalls it
        echo -n %{%F{blue}%}"[$DIR]"
    else
        DIR=$(pwd | sed -r "s|$HOME|~|g")
        echo -n %{%F{blue}%}"[$DIR]"
    fi
}

# Shows current ram usage
function RamUsage() {
    if [[ $showSysInfo == true ]]; then
        echo "<$(free -m | grep -Eo '[0-9]*' | head -7 | tail -1) MB | "
    fi
}


function SensorTemp() {
    # Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
    if [[ $showSysInfo == true ]]; then
        echo "$(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -1)> "
    fi
}

exitCode=0
#Note: the prompt function is not allowed to globally change any variable values; only the PROMPT_COMMAND / precmd() is able
setopt prompt_subst
function precmd() { # zsh equivalent of PROMPT_COMMAND in bash
    GetExitCode
    prompt1="$(tput bold)$(Time) $(RamUsage)$(SensorTemp)$(User)$(Pulse) $(Pwd)$(Sign)
%{%F{white}%}>> "
    PS1=$prompt1

    RPROMPT="%{$GIT_PROMPT_INFO%}$(git_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status)"
    RPS1="${RPROMPT}"
}

if [[ "$TERM" =~ "256color" ]]; then
    is256ColorTerm=true
    if [[ "$TERM" =~ "rxvt" ]]; then
        export REALTERM=$TERM
        export TERM="xterm"
    fi
else
    is256ColorTerm=false
fi

prompt1="$(tput bold)$(Time) $(RamUsage)$(SensorTemp)$(User)$(Pulse) $(Pwd)$(Sign)
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
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[190]%}∆%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[050]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[160]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="\u26c1"
ZSH_THEME_GIT_PROMPT_DIVERGED="⑂"
# }}}

# Configuration options
shortenPath=false
showHostname=false
showPulse=true
showSysInfo=true

# Configuration aliases
alias shorton="export shortenPath=true"
alias shortoff="export shortenPath=false"
alias pulseon="export showPulse=true"
alias pulseoff="export showPulse=false"
alias hoston="export showHostname=true"
alias hostoff="export showHostname=false"
alias syson="export showSysInfo=true"
alias sysoff="export showSysInfo=false"

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
# import aliases from bash
if [[ -e $HOME/.bash_aliases ]]; then
    . $HOME/.bash_aliases
fi
# import zsh-specific aliases
if [[ -e $HOME/.zsh_aliases ]]; then
    . $HOME/.zsh_aliases
fi
# }}}
