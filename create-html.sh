#!/bin/bash

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

cat <<EOF
<html>
  <head><title>OpenSCAD comparison</title></head>
  <body>
    <h1>OpenSCAD comparison</h1>
    <table>
EOF

echo "<thead><tr>"
for v in $1; do
    echo -n "<td><strong>$v</strong></td>"
done
shift
echo "</tr></thead>"

echo "<tbody>"

for f in $@; do
  if [ -s $f ]; then
      # folder/<THINGID>
      [[ $f =~ ^[^\/]+/([[:digit:]]+) ]]
      THINGID=${BASH_REMATCH[1]}
      FILE=$(basename "$f" .scad)
      echo "<tr><td colspan=\"2\" align=\"center\">$THINGID - $FILE</td></tr><tr>"
      cat $f
  fi
done

cat <<EOF
      </tbody>
    </table>
</body></html>
EOF

