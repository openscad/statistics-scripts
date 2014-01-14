#
# Usage: process.sh [-v] <version> <inputfile.scad> <outputfile.png>
#

# Use -v flag to enable debug mode
while getopts 'v' c
do
  case $c in
    v) set -x ;;
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

echo "$THINGID -> $VERSION"

mkdir -p "$RESULTDIR/$OUTDIR"
t=$({ time $OPENSCAD "$INPUT" -o "$OUTPUT" > "$RESULTDIR/$OUTDIR/$FILE.log" 2>&1 ; } 2>&1)
if [[ $? != 0 ]]; then
    echo $? > "$RESULTDIR/$OUTDIR/$FILE-failed.txt"
fi
echo $t > "$RESULTDIR/$OUTDIR/$FILE-time.txt"

if [ ! -s $OUTPUT ]; then
  touch $OUTPUT
fi
