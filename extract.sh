#!/bin/sh

INPUT=/usr/share/gnome-shell/gnome-shell-theme.gresource
OUTPUT=theme
while (( "$#" )); do
	case "$1" in
	-i|--input)
		INPUT=$2
		shift 2
		;;
	-o|--OUTPUT)
		OUTPUT=$2
		shift 2
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

if [ ! -f $INPUT ]; then
	echo "Error: No such file $INPUT"
	exit
fi

echo Extract $INPUT to $OUTPUT
echo

if [ -d $OUTPUT ]; then
	rm -rf $OUTPUT
fi

for i in `gresource list $INPUT`; do
	resource=${i#\/org\/gnome\/shell\/theme/}
	RES_DIR=$OUTPUT/`dirname $resource`
	if [ ! -d $RES_DIR ]; then
		mkdir -p $RES_DIR
	fi		
	echo Extract $resource to $OUTPUT/$resource
	gresource extract $INPUT $i > $OUTPUT/$resource
done
