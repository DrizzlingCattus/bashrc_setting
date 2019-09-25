c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_yellow=`tput setaf 3`
c_blue=`tput setaf 4`
c_magent=`tput setaf 5`
c_cyan=`tput setaf 6`
c_sgr0=`tput sgr0`

parse_git_branch ()
{
   if git rev-parse --git-dir >/dev/null 2>&1
   then
      gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
   else
      return 0
   fi
   echo -e $gitver
}

branch_color ()
{
   if git rev-parse --git-dir >/dev/null 2>&1
   then
      color=""
      if git diff --quiet 2>/dev/null >&2
      then
         color="${c_green}"
      else
         color=${c_red}
      fi
   else
      return 0
   fi
   echo -ne $color
}

PS1=''
PS1+='\[${c_yellow}\]➡ '
PS1+='\[${c_cyan}\]\W'
PS1+='\[${c_sgr0}\]('
PS1+='\[$(branch_color)\]$(parse_git_branch)'
PS1+='\[${c_sgr0}\])'
PS1+='\[${c_yellow}\]\$ '
PS1+='\[${c_sgr0}\]'
export PS1;
