

function __get_tab_title() {
    echo "\[\033]0;\u:\w\007\]"
}

#PS1+="\[\033]0;\u:\w\007\]"

# if attach back slash in front of $, it cannot evaluate normally
# and without it, it can re-evaluate function
# why.... 
PS1+="$(__get_tab_title)"

