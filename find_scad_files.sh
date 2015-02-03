#!/bin/bash

rm -f scadfiles-preview.txt
rm -f scadfiles-render.txt
for f in unpacked/*; do
  # folder/<THINGID>
  [[ $f =~ ^[^\/]+/([[:digit:]]+) ]]
  THINGID=${BASH_REMATCH[1]}

  if [[ `cat things.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) ]]; then
    if [[ ! `cat things-exclude.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) ]]; then
      files=$(find -s $f -name "*.scad" -print -quit)
      echo $files >> scadfiles-preview.txt
      if [[ ! `cat things-exclude-render.txt` =~ (^|[[:space:]])"$THINGID"($|[[:space:]]) ]]; then
          echo $files >> scadfiles-render.txt
      else
          echo "Excluding thing $THINGID from Render mode"
      fi
    else
      echo "Excluding thing $THINGID"
    fi
  else
    echo "Warning: Thing $THINGID not in things.txt"
  fi

done
