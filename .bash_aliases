# Git aliases
alias g="git"
alias ga="git add"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias gcmsg="git commit -m"
alias glog="git log --oneline --decorate --color --graph"

# mplayer aliases
alias news="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/news.pls" # MPR News
alias current="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/the_current.pls" # The Current
alias classical="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/classical.pls" # Classical MPR
alias localcurrent="mplayer -playlist http://minnesota.publicradio.org/tools/play/streams/local.pls" # Local Current
alias sleepbot="mplayer -playlist http://sleepbot.com/ambience/cgi/listen.cgi/listen.pls" # Sleepbot Environmental Broadcast 56K MP3
alias groovesalad="mplayer -playlist http://somafm.com/groovesalad130.pls" # Soma FM Groove Salad iTunes AAC 128K

# networking aliases
alias tunnel="sshuttle 0/0 -r"
alias school="ssh james.wang@marge.stuy.edu"
alias picoctf="ssh pico49524@shell2014.picoctf.com"
alias easyctf="ssh user04ce4@ssh.easyctf.com"

# Other aliases
alias aptproxyget='sh ~/.aptproxyget/apt-proxy-get.sh'
alias homeworkserver='~/.homeworkserver/homeworkserver'
alias updatevim="~/scripts/update_vim.sh"
alias updateneovim="~/scripts/update_neovim.sh"
# For long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
