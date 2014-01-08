#!/bin/bash
rm -f unpack.log
for z in zip/*.zip; do
  id=`basename $z .zip`
  echo $id
  mkdir -p unpacked/$id && cd unpacked/$id && unzip -q ../../$z && cd ../..
  # FIXME: Escape spaces in filenames
  find unpacked/$id -name "*.scad" >> unpack.log
done
