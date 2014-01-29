#
# Usage: process.sh [-vr] <version> <inputfile.scad> <outputfile.png>
#

RENDER=

# Use -v flag to enable debug mode
while getopts 'vr' c
do
  case $c in
    v) set -x ;;
    r) RENDER="--render" ;;
  esac
done
shift $(($OPTIND - 1))

VERSION=$1
INPUT=$2
OUTPUT=$3

OPENSCAD=/Users/kintel/Desktop/OpenSCAD-$VERSION.app/Contents/MacOS/OpenSCAD 
export OPENSCADPATH=$PWD/customizer-libraries
export TIMEFORMAT='%1U'

RESULTDIR=results-$VERSION
DIR=$(dirname "$INPUT")
OUTDIR=${DIR#unpacked/}
THINGID=${OUTDIR%%/*}
FILE=$(basename "$INPUT" .scad)
if [ $RENDER ]; then
  TIMEOUT=3600
else
  TIMEOUT=1000
fi

echo "$THINGID -> $VERSION"

mkdir -p "$RESULTDIR/$OUTDIR"
t=$({ time timeout $TIMEOUT $OPENSCAD "$INPUT" -o "$OUTPUT" $RENDER > "$RESULTDIR/$OUTDIR/$FILE.log" 2>&1 ; } 2>&1)
retval=$?
if [[ $retval != 0 ]]; then
    echo $retval > "$RESULTDIR/$OUTDIR/$FILE-failed.txt"
    if [[ $retval == 137 ]]; then
        echo $THINGID >> killed.txt
    fi
fi
echo $t > "$RESULTDIR/$OUTDIR/$FILE-time.txt"

if [ ! -s $OUTPUT ]; then
  touch $OUTPUT
fi
