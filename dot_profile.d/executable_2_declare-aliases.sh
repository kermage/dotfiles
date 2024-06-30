alias ls='eza --git --icons --classify --group-directories-first --time-style=long-iso --group --color-scale'
alias gl='git log --oneline --graph --decorate'

mkcd() { mkdir $1 && cd $1; }
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ga='git add'
alias gb='git branch'
alias gch='git checkout'
alias gcl='git clone'
alias gc='git commit'
gcm() { git commit -m "$*"; }
gcmp() { git commit -m "$*" && git push; }
alias gd='git diff'
alias gr='git remote'
alias gpu='git pull'
alias gp='git push'
alias gpd='git push origin develop'
alias gpm='git push origin main'
alias gs='git status'
alias gfs='git fetch && git status'
