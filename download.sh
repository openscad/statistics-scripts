#!/bin/bash

mkdir -p zip
for thing in `cat things.txt`; do
  curl -L http://www.thingiverse.com/thing:$thing/zip -o $thing.zip
  sleep 0.5
done
