alias cp="cp -i"                #  confirm before overwriting something
alias df='df -h'                # human-readable sizes
alias du='du -h'                # ditto
alias free='free -m'            # show sizes in MB
alias rm='rm -iv'               # confirm before deletion
alias wpm="/home/jmfrees/.local/share/virtualenvs/wpm-gVYDynyg/bin/python -m wpm"

# alias for git directory belonging to my dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

starship init fish | source

# Created by `pipx` on 2021-05-15 00:36:32
set PATH $PATH /home/jmfrees/.local/bin
