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
export PATH="/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/games:/usr/sbin"
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

ZSH_THEME="pre-oh-my-zsh" # Theme to be used

COMPLETION_WAITING_DOTS="true" # Display red dots whilst waiting for completion

DISABLE_UNTRACKED_FILES_DIRTY="true" # Mark untracked files under VCS as dirty

plugins=(git git-flow zsh-syntax-highlighting) # Plugins

# User configuration

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

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
eval $(thefuck --alias)

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
autoload predict-off
# use advanced completion system
autoload -U compinit && compinit
# colors
autoload -U colors && colors

# Override colors
ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"

. /etc/zsh_command_not_found # Bash-like command not found
