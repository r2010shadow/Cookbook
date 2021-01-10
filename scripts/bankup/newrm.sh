#!/bin/bash

# newrm replace rm, move files to $HOME/.deleted-files/

# alias rm=yourpath/newrm.sh

archivedir="$HOME/.deleted-files"
realrm="$(which rm)"
copy="$(which cp) -R"
if [ $# -eq 0 ] ; then
	exec $realrm
fi

flags=""

while getopts "dfiPRrvW" opt
do
	case $opt in
		f ) exec $realrm "$@" ;;
		* ) flags="$flags -$opt" ;;
	esac
done
shift $(( $OPTIND - 1 ))


if [ ! -d $archivedir ] ; then
	if [ ! -w $HOME ] ; then
		echo "$0 failed: can not create $archivedir in $HOME" >&2
		exit 1
	fi
	mkdir $archivedir
	chmod 700 $archivedir
fi

for arg
do
	newname="$archivedir/$(date "+%H:%M:%S-%m%d").$(basename "$arg")"
	if [ -f "$arg" -o -d "$arg" ] ; then
		$copy "$arg" "$newname"
	fi
done


exec $realrm $flags "$@"





