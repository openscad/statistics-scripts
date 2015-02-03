#!/bin/bash

#
# Collect timing info and bitmap results of all tests
# Input: scadfiles.txt
# Process: <for each VERSION>
# o Find corresponding *-time.txt result containing processing time
# o Find corresponding *.png result containing rendering
#   - If all bitmaps are present and non-zero, compare them
#
# o For each entry, output to times.csv:
#   Thing ID, [time per version], <bitmap changed flag>
#
# FIXME
# o Cache csv (and html) entry per thing (or makefile) ?
#   - entry is depending on -time.txt and .png
# o Support multiple entries per thing?
# 
#

VERSIONS="2013.06 2014.03 master"
FILES=scadfiles.txt
#FILES=testfiles.txt

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done

rm -f times.csv
echo -n "Thing ID" >> times.csv

rm -f comparison.html
cat > comparison.html <<EOF
<html>
  <head><title>OpenSCAD comparison</title></head>
  <body>
    <h1>OpenSCAD comparison</h1>
    <table>
      <thead>
        <tr>
EOF

for v in $VERSIONS; do
  echo -n ",$v" >> times.csv
  echo -n "<td><strong>$v</strong></td>" >> comparison.html
done
echo ",changed" >> times.csv

cat >> comparison.html <<EOF
</tr>
      </thead>
      <tbody>
EOF

for f in `cat $FILES`; do
  DIR=$(dirname "$f")
  OUTDIR=${DIR#unpacked/}
  THINGID=${OUTDIR%%/*}
  echo -n "$THINGID" >> times.csv
  FILE=$(basename "$f" .scad)
  bitmaps=""
  html="<tr><td colspan=\"2\" align=\"center\">$THINGID - $FILE</td></tr><tr>"
  for v in $VERSIONS; do
    RESULTDIR=results-$v
    echo -n "," >> times.csv
    echo -n `cat "$RESULTDIR/$OUTDIR/$FILE-time.txt"` >> times.csv
    html+="<td><img src=\"$RESULTDIR/$OUTDIR/$FILE.png\" width=\"250\"/></td>"
    bitmaps+=" $RESULTDIR/$OUTDIR/$FILE.png"
  done

  failed=false

  for b in $bitmaps; do
    if [ ! -s $b ]; then failed=true; fi
  done

  if ! $failed; then
    result=`./compare-bitmaps.sh $bitmaps 2>&1`
    if [[ $? != 0 ]]; then
      failed=true
#      echo "$THINGID - $FILE compare failed: $result"
    fi
  fi

  echo ",$failed" >> times.csv

  if $failed; then
    echo $html >> comparison.html
    echo "</tr>" >> comparison.html
  fi
done

cat >> comparison.html <<EOF
      </tbody>
    </table>
</body></html>
EOF

