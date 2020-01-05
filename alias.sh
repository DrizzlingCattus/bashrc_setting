# simple alias commands

cdls() { cd "$@" && ls; }
lsgrep() { ls | grep "$@"; }


# simple alias string

## Due to the use of nodejs instead of node name in some distros, yarn might complain about node not being installed.
## A workaround for this is to add an alias in your .bashrc file, like so: alias node=nodejs.
## This will point yarn to whatever version of node you decide to use
#alias node=nodejs

alias vi='nvim'
alias vim='nvim'

