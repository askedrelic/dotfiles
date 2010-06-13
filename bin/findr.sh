#!/bin/bash

 usage="\nfindr.sh: Helper to make regex find commands easier.\n\n"
usage+="  usage: findr.sh [-a] [-p preview mode] [find args] expression\n"
usage+="\t-a\tsearch all filesystems (default is -xdev/-mount)\n"
usage+="\t-p\tpreview mode; just show the resulting find command\n"
usage+="\n\t\t(can't combine params, e.g. -ap)\n"

preview=false
# use "nowarn" to avoid warning if -mount used after -type f, e.g.
xdev=" -nowarn -mount "

while [[ -n "$1" ]]; do
	if [[ $1 == "-h" || $1 == "--help" || $1 == "-help" ]]; then
		echo -e $usage
		exit 0
	elif [[ $1 == "-a" ]]; then
		xdev=""
	elif [[ $1 == "-p" ]]; then
		preview=true
	elif [[ $# -eq 1 ]]; then
		regex=$1
	else
		args+=" $1"
	fi
	shift
done

args+="${xdev}-regextype posix-egrep -iregex"
regex="^.*${regex}[^/]*$"

if [[ "$preview" == "true" ]]; then
	echo "find $args \"$regex\"" >&2
else
	find $args "$regex"
fi