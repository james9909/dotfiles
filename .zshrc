# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── OS detection ────────────────────────────────────────────────
case "$(uname -s)" in
    Darwin)
        export DOTFILES_OS=macos ;;
    Linux)
        if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
            export DOTFILES_OS=wsl
        else
            export DOTFILES_OS=linux
        fi
        ;;
    *) export DOTFILES_OS=unknown ;;
esac

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ── History ─────────────────────────────────────────────────────
HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# ── Core options ────────────────────────────────────────────────
export EDITOR="vim"

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

# ── Theme & plugins ─────────────────────────────────────────────
ZSH_THEME="powerlevel10k/powerlevel10k"

COMPLETION_WAITING_DOTS="true"       # Display red dots whilst waiting for completion
DISABLE_UNTRACKED_FILES_DIRTY="true" # Mark untracked files under VCS as dirty

plugins=(git zsh-syntax-highlighting tmux)

# ── Aliases ─────────────────────────────────────────────────────
[[ -e $HOME/.bash_aliases ]] && . $HOME/.bash_aliases
[[ -e $HOME/.zsh_aliases ]]  && . $HOME/.zsh_aliases

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export UPDATE_ZSH_DAYS=2
alias zshreload="source ~/.zshrc"

# ── fzf ─────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --ignore-file ~/.gitignore_global -g "!{node_modules,.git,.cache}" --follow'

# ── Completion styling ──────────────────────────────────────────
zstyle ':completion::complete:*' use-cache 1              # use cache when auto-completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'       # case-insensitive completion
zstyle ':completion:*' menu select                        # graphical auto-complete menu
zstyle ':notify:*' command-complete-timeout 5             # alert after commands >5s
zstyle ':notify:*' always-notify-on-failure no

# ── Terminal ────────────────────────────────────────────────────
export TERM="xterm-256color"    # xterm because of urxvt backspace bugs
export REALTERM="rxvt-unicode-256color"

ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"

# Tmux
export ZSH_TMUX_AUTOSTART="false"
export ZSH_TMUX_AUTOCONNECT="true"

# ── Misc tooling ──
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

# Go
export GOPATH="$HOME/Dev/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
if command -v rustc >/dev/null 2>&1; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/library"
fi

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dev
if [ -f ~/.local/bin/virtualenvwrapper_lazy.sh ]; then
    export VIRTUALENVWRAPPER_SCRIPT=~/.local/bin/virtualenvwrapper.sh
    source ~/.local/bin/virtualenvwrapper_lazy.sh
fi

# rbenv
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

# nix
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# ── Platform-specific setup ─────────────────────────────────────
_dotfiles_platform_macos() {
    export PATH="/opt/homebrew/bin:$PATH"
}

_dotfiles_platform_linux() {
    [ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found
    [ -d /snap/bin ] && export PATH="$PATH:/snap/bin"
}

case "$DOTFILES_OS" in
    macos)     _dotfiles_platform_macos ;;
    linux|wsl) _dotfiles_platform_linux ;;
esac

# ── p10k prompt ─────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Machine-local overrides ─────────────────────
# Per-machine paths, secrets, and work/host-specific tooling belong in
# ~/.zshrc.local — never in this file. See .zshrc.local.example.
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
