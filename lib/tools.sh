# load shell scrirpts
# param1 : array of paths
load_files() {
    local files=$1
    for i in $files ; do
	if [ -r "$i" ]; then
	    if [ "${-#*i}" != "$-" ]; then
		source "$i"
	    else
		source "$i" >/dev/null
	    fi
	fi
    done

    unset i
}
