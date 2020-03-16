#!/bin/bash

INPUT=theme
while (( "$#" )); do
	case "$1" in
	-i|--input)
		INPUT=$2
		shift 2
		;;
	-a|--apply)
		APPLY_FLAG=true
		shift 1
		;;
	--) # end argument parsing
		shift
		break
		;;
	-*|--*=) # unsupported flags
		echo "Error: Unsupported flag $1" >&2
		exit 1
		;;
	*) # preserve positional arguments
		echo "Error: Unsupported argument $1" >&2
		shift
		;;
	esac
done

if [ ! -d $INPUT ]; then
	echo "Error: No such directory $INPUT"
	exit
fi
FILES=$(find "theme" -type f -printf "%P\n" | xargs -i echo "    <file>{}</file>")

cat <<EOF >"gnome-shell-theme.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
$FILES
  </gresource>
</gresources>
EOF

glib-compile-resources --sourcedir=$INPUT gnome-shell-theme.gresource.xml

echo "-> gnome-shell-theme.gresource"

if [ -z $APPLY_FLAT ]; then
	echo "Making backup"
	cp /usr/share/gnome-shell/gnome-shell-theme.gresource gnome-shell-theme.gresource.bak
	echo "Applying gnome-shell-theme"
	sudo cp gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
fi

