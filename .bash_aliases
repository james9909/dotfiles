# Git aliases
alias g="git"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias gcmsg="git commit -m"
alias glog="git log --oneline --decorate --color --graph"

alias school="ssh james.wang@marge.stuy.edu"
alias aptproxyget='sh ~/.aptproxyget/apt-proxy-get.sh'
alias homeworkserver='~/.homeworkserver/homeworkserver'
alias easyctf="ssh user04ce4@ssh.easyctf.com"
alias updatevim="~/scripts/update_vim.sh"
alias updateneovim="~/scripts/update_neovim.sh"
# For long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
