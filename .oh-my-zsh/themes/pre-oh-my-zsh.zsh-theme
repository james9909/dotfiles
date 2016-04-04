#!/usr/bin/env zsh
# Color support {{{

# Force color in terminal
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
    export TERM=screen-256color
fi

if [[ "$TERM" =~ "256color" ]]; then
    is256ColorTerm=true
else
    is256ColorTerm=false
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

# }}}
# Prompt {{{

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
RESET="\033[m"

# Get the exit code
function get_exit_code() {
    exitCode=$?
}

# Changes the sign of the user based on various conditions
function get_sign() {
    if [[ $UID == 0 ]]; then
        # The sign changes based on whether or not the user inputted a valid command
        if [[ $exitCode == 0 ]]; then
            echo "${GREEN}#"
        else
            echo "${RED}# [$exitCode]"
        fi
    else
        # The sign changes based on whether or not the user inputted a valid command
        if [[ $exitCode == 0 ]]; then
            echo "${GREEN}:)"
        else
            echo "${RED}:( [$exitCode]"
        fi
    fi
}

# Shows the current time
function get_time() {
    echo "${GREEN}[$(date '+%I:%M')]"
}

# Alters the display of the user
function user() {
    echo -n "${RED}$USER"
    if $showHostname; then
        echo -n "${RED}@$(hostname)"
    fi
}

# Appends a pulse to the user name
function pulse() {
    if $showPulse; then
        echo "${RED}[~^v~]"
    fi
}

# Shows the present working directory
function get_pwd() {
    if $shortenPath; then
        DIR=$(pwd | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g") # (.) holds the first letter and \1 recalls it
    else
        DIR=$(pwd | sed -r "s|$HOME|~|g")
    fi
    echo -n "${BLUE}[$DIR]"
}

# Shows current ram usage
function show_sys_info() {
    if $showSysInfo; then
        echo "${GREEN}<$(free -m | grep -Eo '[0-9]*' | head -7 | tail -1) MB | $(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -1)>"
    fi
}

function prompt_cmd() {
    get_exit_code
    echo "$(tput bold)$(get_time) $(show_sys_info) $(user)$(pulse) $(get_pwd)$(count_jobs) $(get_sign)
${WHITE}>> "
}

function rprompt_cmd() {
    echo "%{$GIT_PROMPT_INFO%}$(git_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status)"
}

function count_jobs() {
    stopped=$(jobs -sp | wc -l)
    running=$(jobs -rp | wc -l)
    ((running+stopped)) && echo "${MAGENTA}[${running}r/${stopped}s]"
}

PROMPT='$(prompt_cmd)' # single quotes to prevent immediate execution
RPROMPT='' # set asynchronously and dynamically

exitCode=0
ASYNC_PROC=0

setopt prompt_subst
function precmd() {
    function async() {
        # save to temp file
        printf "%s" "$(rprompt_cmd)" > "${HOME}/.zsh_tmp_prompt"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat ${HOME}/.zsh_tmp_prompt)"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    # https://github.com/zsh-users/zsh-syntax-highlighting/issues/230
    zle && zle .reset-prompt
}

# {{{ Git Prompt

PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]

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
ZSH_THEME_GIT_PROMPT_STASHED="*"
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
