source $HOME/.bashrc.d/lib/tools.sh

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

__paint_color() {
    local is_delay="$1"
    local color_v="$2"
    local target="$3"
    if [ 'f' == "$is_delay" ] ; then
	echo "\[$(tput setaf $color_v)$target\]"
    elif [ 't' == "$is_delay" ] ; then
	echo "$(tput setaf $color_v)$target"
    else
	echo ""
    fi
}


# get current branch in git repo
__print_git_branch() {
    local BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    echo "$(__paint_color 't' $blue ${BRANCH})"
}

__print_git_stat() {
    echo "$(__paint_color 't' $yellow $(__parse_git_dirty))"
}

# get current status of git repo
__parse_git_dirty() {
    local status=`git status 2>&1 | tee`
    local dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    local untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    local ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    local newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    local renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    local deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    local bits=''
    #debug_v prev_cond $bits
    if [ "${renamed}" == "0" ]; then
	#debug_v renamed $bits
	bits=">${bits}"
    fi
    # DO NOT USE! cuz it occur problem unexpected output
    #if [ "${ahead}" == "0" ]; then
    #    #debug_v ahead $bits
    #    bits="*${bits}"
    #fi
    if [ "${newfile}" == "0" ]; then
	#debug_v newfile $bits
	bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
	#debug_v untracked $bits
	bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
	#debug_v deleted $bits
	bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
	#debug_v dirty $bits
	bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
	#debug_v result_bit_non_null $bits
	echo "${bits}"
    else
	#debug_v result_bit_null $bits
	echo ""
    fi
}


PS1="" # initiate

# Forward PS1 processing
forward_directory_path="$HOME/.bashrc.d/forward.ps1.d"
load_files "$forward_directory_path/*.sh"
unset forward_directory_path

#PS1+="$(__paint_color 'f' $green '[')" # start next info part
#PS1+="$(__paint_color 'f' $white '\D{%Y-%m-%d %H:%M:%S}')" # date with time like 2019-06-07 07:19:30
#PS1+="$(__paint_color 'f' $green ']')" # end next info part 
PS1+='➡ '

PS1+="$(__paint_color 'f' $magenta '\W')" # current working directory
PS1+="$(__paint_color 'f' $blue '(')"
PS1+="\[\$(__print_git_branch)\]"
PS1+="\[\$(__print_git_stat)\]"
PS1+="$(__paint_color 'f' $blue ')')"

# BUG:: arrow symbol occur problem that text is not wrapping second line 
#PS1+=" ${green}➜ \[\e[m\]" # command start symbol
PS1+="$(__paint_color 'f' $green @) ${init_color}"

# Backward PS1 processing 
backward_directory_path="$HOME/.bashrc.d/backward.ps1.d"
load_files "$backward_directory_path/*.sh"
unset backward_directory_path

export PS1;

