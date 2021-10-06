#
# ~/.bashrc
#

[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

export TERM='rxvt-unicode-256color';

use_color=true

# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
fi

unset use_color safe_term match_lhs sh

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# allows completion for aliases
shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend
# ignore duplicate history entries
export HISTCONTROL=ignoredups:erasedups

# Functions
prompt_git() {
    local s=''
    local branchName=''

    # Check if the current directory is in a Git repository.
    if [ $(
        git rev-parse --is-inside-work-tree &>/dev/null
        echo "${?}"
    ) == '0' ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" == 'false' ]; then

            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null

            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+'
            fi

            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules); then
                s+='!'
            fi

            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?'
            fi

            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$'
            fi

        fi

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
            git rev-parse --short HEAD 2>/dev/null ||
            echo '(unknown)')"

        [ -n "${s}" ] && s="[${s}]"

        echo -e "${1}${branchName}${2}${s}"
    else
        return
    fi
}

up() { # moves up a number of dirs specified
    local d=""
    limit=$1
    for ((i = 1; i <= limit; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

ex() { # attempts to extract input file
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
# End Functions

# Aliases
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
# End Aliases

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    userStyle="${bold}${red}"
else
    userStyle="${bold}${lightyellow}"
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    hostStyle="${bold}${red}"
else
    hostStyle="${bold}${cyan}"
fi

PS1="\[${reset}\]"                                                            # begin prompt; prevent commands affecting it
PS1+="\[${white}\]["                                                          # opening bracket
PS1+="\[${userStyle}\]\u"                                                     # username
PS1+="\[${white}\]@"                                                          # connection btwn user and host
PS1+="\[${hostStyle}\]\h"                                                     # host
PS1+="\[${reset}\]"                                                           # clear formatting for user/host
PS1+="\[${lightgreen}\] \w"                                                   # working directory full path
PS1+="\$(prompt_git \"\[${white}\] on \[${lightred}\]\" \"\[${lightred}\]\")" # Git repository details
PS1+="\[${white}\]]\$ "                                                       # closing bracket
PS1+="\[${reset}\]"                                                           # clear for user input
export PS1

PS2="\[${white}\]> \[${reset}\]"
export PS2
# End Prompt

export EDITOR='vim'
export BROWSER='firefox'
