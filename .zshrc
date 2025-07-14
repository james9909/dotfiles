# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export PATH="/opt/homebrew/bin:$PATH"
export EDITOR="nvim"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt COMPLETE_IN_WORD
setopt ZLE
unsetopt EQUALS
unsetopt correct_all
unsetopt correct

bindkey '^[[Z' reverse-menu-complete

ZSH_THEME="powerlevel10k/powerlevel10k" # Theme to be used

COMPLETION_WAITING_DOTS="true" # Display red dots whilst waiting for completion

DISABLE_UNTRACKED_FILES_DIRTY="true" # Mark untracked files under VCS as dirty

OS="$(uname)"

if [[ $OS == "Darwin" && -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
plugins=(git zsh-syntax-highlighting tmux) # Plugins

# User configuration {{{

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

# }}}

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

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --ignore-file ~/.gitignore_global -g "!{node_modules,.git,.cache}" --follow'

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

# Override colors
ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"

# Tmux
export ZSH_TMUX_AUTOSTART="false"
export ZSH_TMUX_AUTOCONNECT="true"

export GOPATH="$HOME/Dev/go"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="$SPICETIFY_INSTALL:$PATH"

# Pretend that we are using Unity (for the settings)
export XDG_CURRENT_DESKTOP=Unity

export XDG_CONFIG_HOME="$HOME/.config"

# Virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dev

if [ -x "$(command -v foo)" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_SCRIPT=~/.local/bin/virtualenvwrapper.sh
fi

if [ -f ~/.local/bin/virtualenvwrapper_lazy.sh ]; then
    source ~/.local/bin/virtualenvwrapper_lazy.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$HOME/discord/.local/bin:$PATH"
#compdef clyde
_clyde() {
  eval "$(_CLYDE_COMPLETE=zsh_source clyde)"
}
if [[ "$(basename -- ${(%):-%x})" != "_clyde" ]]; then
  compdef _clyde clyde
fi

source $HOME/.nix-profile/etc/profile.d/nix.sh

# pnpm
export PNPM_HOME="/Users/james/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/library"
