#!/bin/bash

mkdir -p zip
for thing in `cat things.txt`; do
  if [ ! -f zip/$thing.zip ]; then
    curl -L http://www.thingiverse.com/thing:$thing/zip -o zip/$thing.zip
    sleep 0.5
  fi
done
