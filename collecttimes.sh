#!/bin/bash

VERSIONS="2013.06 master refactor"

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

for f in `cat allfiles.txt`; do
#for f in `cat testfiles.txt`; do
#for f in unpacked/10113/Parametric_glassvasemug/glass.scad; do
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

