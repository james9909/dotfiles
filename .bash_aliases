# Git aliases
alias g="git"
alias ga="git add"
alias gd="git diff"
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

# Other aliases
alias emacs="echo 'nice try'; sleep .5; vim"
alias homeworkserver='~/.homeworkserver/homeworkserver'
# For long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias weather='curl -s wttr.in | head -n 7'
alias mountwindows='sudo mount -t ntfs-3g -ro remove_hiberfile /dev/sda3 /media/windows'
alias downloadmoreram='sudo sysctl vm.drop_caches=3'
alias hotspoot='sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65' # https://www.reddit.com/r/hacking/comments/54a7dd/_/

alias eclipse='GTK_THEME=Default:light ~/eclipse/eclipse &> /dev/null & disown'
alias gdb='gdb -q'
alias pmake='time nice make -j$(nproc) -l $(nproc)'
alias disablemouse='sudo xinput set-prop 11 "Device Enabled" 0'
alias enablemouse='sudo xinput set-prop 11 "Device Enabled" 1'
alias whomst='git blame'
alias py='python3'
alias vim='nvim'
alias workman='setxkbmap -v us workman'
alias qwerty='setxkbmap -v us'
