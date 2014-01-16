#!/bin/bash

#
# Usage:
#   collect-html.sh <png-files>
#

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

failed=false
for b in $@; do

    # results-<version>/<THINGID>
    [[ $b =~ ^results-([^\/]+)/([[:digit:]]+) ]]
    VERSION=${BASH_REMATCH[1]}
    THINGID=${BASH_REMATCH[2]}

    # Check if we should ignore results (e.g. due to refactored version
    # having different OpenCSG rendering artifacts). NB! only do this 
    # for manually verified models.
    if [[ ! `cat things-ignore-bitmaps.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) &&
          ! `cat things-ignore-$VERSION-bitmaps.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) ]]; then
        bitmaps="$bitmaps $b"
        if [ ! -s $b ]; then 
          failed=true;
        fi
    fi
done

if [[ -n "$bitmaps" && ! $failed ]]; then
    result=`./compare-bitmaps.sh $bitmaps 2>&1`
    if [ $? -ne 0 ]; then
        failed=true
    fi
fi

if $failed; then
    echo "<tr>"
    for b in $@; do
        echo "<td><img src=\"$b\" width=\"250\"/></td>"
    done
    echo "</tr>"
fi
