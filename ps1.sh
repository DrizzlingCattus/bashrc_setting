source lib/tools.sh

# Colors
# reference) http://linuxcommand.org/lc3_adv_tput.php
# BUG:: text not wrapping second line if use tput
init_color="\[\e[m\]"

black=0
red=1
green=2
yellow=3
blue=4
magenta=5
cyan=6
white=7

paint_color() {
    local is_delay=$1
    local color_v=$2
    local target=$3
    if [ 'f' == $is_delay ] ; then
	echo "\[$(tput setaf $color_v)$target\]"
    elif [ 't' == $is_delay ] ; then
	echo "$(tput setaf $color_v)$target"
    fi
}


# get current branch in git repo
__print_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    echo "$(paint_color 't' $blue ${BRANCH})"
}

__print_git_stat() {
    echo "$(paint_color 't' $yellow $(parse_git_dirty))"
}

# get current status of git repo
parse_git_dirty() {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
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


PS1="" # initiate

# Forward PS1 processing
forward_directory_path="$HOME/.bashrc.d/forward.ps1.d"
load_files "$forward_directory_path/*.sh"
unset forward_directory_path

PS1+="$(paint_color 'f' $green '[')" # start next info part
PS1+="$(paint_color 'f' $white '\D{%Y-%m-%d %H:%M:%S}')" # date with time like 2019-06-07 07:19:30
PS1+="$(paint_color 'f' $green ']')" # end next info part 

PS1+="$(paint_color 'f' $magenta '\W')" # current working directory
PS1+="$(paint_color 'f' $blue '(')"
PS1+="\[\$(__print_git_branch)\]"
PS1+="\[\$(__print_git_stat)\]"
PS1+="$(paint_color 'f' $blue ')')"

# BUG:: arrow symbol occur problem that text is not wrapping second line 
#PS1+=" ${green}➜ \[\e[m\]" # command start symbol
PS1+="$(paint_color 'f' $green @) ${init_color}"

# Backward PS1 processing 
backward_directory_path="$HOME/.bashrc.d/backward.ps1.d"
load_files "$backward_directory_path/*.sh"
unset backward_directory_path

export PS1;

