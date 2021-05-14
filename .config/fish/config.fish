alias cp="cp -i"                #  confirm before overwriting something
alias df='df -h'                # human-readable sizes
alias du='du -h'                # ditto
alias free='free -m'            # show sizes in MB
alias rm='rm -iv'               # confirm before deletion
alias ':q'=exit
alias ':e'=vim
alias vi=vim
alias wpm="/home/jmfrees/.local/share/virtualenvs/wpm-gVYDynyg/bin/python -m wpm"
alias weather="curl wttr.in"
alias diff='colordiff'
alias sp='termite & disown'
alias pvim='pdm run vim'

# alias for git directory belonging to my dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

starship init fish | source
