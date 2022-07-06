alias cp="cp -i"                #  confirm before overwriting something
alias free='free -m'            # show sizes in MB
alias rm='rm -iv'               # confirm before deletion
alias vim='lvim'
# alias for git directory belonging to my dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

set --export PATH $PATH $HOME/.local/bin

starship init fish | source
