
# Colors
# reference) http://linuxcommand.org/lc3_adv_tput.php
# BUG:: text not wrapping second line if use tput
init_color="\[\e[m\]"
black="\[$(tput setaf 0)\]"
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
magenta="\[$(tput setaf 5)\]"
cyan="\[$(tput setaf 6)\]"
white="\[$(tput setaf 7)\]"

#red="\[\e[0;31m\]"
#green="\[\e[0;32m\]"
#blue="\[\e[34m\]"
#magenta="\[\e[0;35m\]"
#white="\[\e[0;37m\]"


# get current branch in git repo
function __print_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function __print_git_stat() {
    parse_git_dirty
}

#function parse_git_branch() {
#    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
#    if [ ! "${BRANCH}" == "" ]
#    then
#	STAT=`parse_git_dirty`
#	echo "\`${blue}(${blue}${BRANCH}${STAT}${blue})\`"
#    else
#	echo ""
#    fi
#}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=""
    if [ "${renamed}" == "0" ]; then
	bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
	bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
	bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
	bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
	bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
	bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
	echo "${bits}"
    else
	echo ""
    fi
}


PS1="${green}[" # start next info part
PS1+="${white}\D{%Y-%m-%d %H:%M:%S}" # date with time like 2019-06-07 07:19:30
PS1+="${green}]" # end next info part 

#PS1+="${green}[" # start next info part
PS1+="${white}\u" # username
PS1+="${green}:" # delimeter
PS1+="${magenta}\W" # current working directory
PS1+="${blue}("
PS1+="\`__print_git_branch\`"
PS1+="${yellow}\`__print_git_stat\`"
PS1+="${blue})"
#PS1+="${green}]" # end next info part

PS1+="${green}@ ${init_color}" # command start symbol
# BUG:: arrow symbol occur problem that text is not wrapping second line 
#PS1+=" ${green}➜ \[\e[m\]" # command start symbol
export PS1;

