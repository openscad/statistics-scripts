#!/bin/bash

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

HTMLFILE=$1

shift

# folder/<THINGID>
[[ $1 =~ ^[^\/]+/([[:digit:]]+) ]]
THINGID=${BASH_REMATCH[1]}

echo -n "$THINGID,"
cat $@ | tr "\n" ","

[ ! -s $HTMLFILE ]
echo $?
exit
