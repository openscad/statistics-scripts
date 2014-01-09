#!/bin/bash

for z in zip/*.zip; do
  id=`basename $z .zip`
  # Only unpacked files that don't already exist
  if [ ! -d unpacked/$id ]; then
      echo $id
      unzip -d unpacked/$id -qo $z

      # Remove spaces in filenames since subsequent makefile doesn't
      # support that
      find unpacked/$id -name "* *.scad" -print0 | xargs -0 -n1 sh -c 'mv "$0" ${0// /_}'
  fi
done
