#!/bin/bash

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

bitmaps=$@

failed=false
for b in $bitmaps; do
    if [ ! -s $b ]; then failed=true; fi
done

if ! $failed; then
    result=`./compare-bitmaps.sh $bitmaps 2>&1`
    if [ $? -ne 0 ]; then
        failed=true
    fi
fi

if $failed; then
    echo "<tr>"
    for b in $bitmaps; do
        echo "<td><img src=\"$b\" width=\"250\"/></td>"
    done
    echo "</tr>"
fi
