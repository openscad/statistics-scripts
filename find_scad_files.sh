#!/bin/bash

rm -f scadfiles.txt
for f in unpacked/*; do
  # folder/<THINGID>
  [[ $f =~ ^[^\/]+/([[:digit:]]+) ]]
  THINGID=${BASH_REMATCH[1]}

  if [[ `cat things.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) ]]; then
    find -s $f -name "*.scad" -print -quit >> scadfiles.txt
  else
    echo "Warning: Thing $THINGID not in things.txt"
  fi

done
