#!/bin/bash

rm -f scadfiles.txt
for f in unpacked/*; do
  find -s $f -name "*.scad" -print -quit >> scadfiles.txt
done
