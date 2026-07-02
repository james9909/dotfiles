# Git aliases
alias g="git"
alias ga="git add"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias gcmsg="git commit -m"
alias glog="git log --oneline --decorate --color --graph"
alias vim='nvim'

# Machine-local aliases
[ -f "$HOME/.bash_aliases.local" ] && . "$HOME/.bash_aliases.local"
