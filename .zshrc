# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# User configuration
export PATH="/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/games:/usr/sbin:/home/james/scripts"
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

ZSH_THEME="oh-my-zsh" # Theme to be used

COMPLETION_WAITING_DOTS="true" # Display red dots whilst waiting for completion

DISABLE_UNTRACKED_FILES_DIRTY="true" # Mark untracked files under VCS as dirty

plugins=(git zsh-syntax-highlighting tmux) # Plugins

# User configuration

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=2

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshreload="source ~/.zshrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # FZF
export FZF_DEFAULT_COMMAND='ag -i --nocolor --nogroup --hidden --ignore .git --ignore .DS_Store --ignore "**/*.pyc" --ignore "**/*.class" --ignore _backup --ignore _undo --ignore _swap --ignore .cache -g ""'

# use cache when auto-completing
zstyle ':completion::complete:*' use-cache 1
# use case-insensitive auto-completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# graphical auto-complete menu
zstyle ':completion:*' menu select

# use automatic path prediction
# $predict-on to turn on and $predict-off to turn off
# autoload predict-off
# use advanced completion system
# autoload -U compinit && compinit
# colors
# autoload -U colors && colors

# Set xterm because of urxvt backspace bugs
export TERM="xterm-256color"
export REALTERM="rxvt-unicode-256color"

# Override colors
ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"

# Tmux
export ZSH_TMUX_AUTOSTART="true"
export ZSH_TMUX_AUTOCONNECT="true"

. /etc/zsh_command_not_found # Bash-like command not found

export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
export RUST_SRC_PATH="${RUST_SRC_PATH}:$HOME/.cargo/registry/src"
export GOPATH="$HOME/Dev/go"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="$HOME/Dev/google_appengine:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dev
export VIRTUALENVWRAPPER_SCRIPT=~/.local/bin/virtualenvwrapper.sh
source ~/.local/bin/virtualenvwrapper_lazy.sh

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f /home/james/Dev/google-cloud-sdk/path.zsh.inc ]; then
#   source '/home/james/Dev/google-cloud-sdk/path.zsh.inc'
# fi

# The next line enables shell command completion for gcloud.
if [ -f /home/james/Dev/google-cloud-sdk/completion.zsh.inc ]; then
  source '/home/james/Dev/google-cloud-sdk/completion.zsh.inc'
fi

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
