#
# Usage: process.sh <version> <file>
#
VERSION=$1
INPUT=$2

OPENSCAD=/Users/kintel/Desktop/OpenSCAD-$VERSION.app/Contents/MacOS/OpenSCAD 
export OPENSCADPATH=/Users/kintel/Desktop/OpenSCAD/Makerbot/customizer-libraries
export TIMEFORMAT='%1U'

RESULTDIR=results-$VERSION
DIR=$(dirname "$INPUT")
OUTDIR=${DIR#unpacked/}
THINGID=${OUTDIR%%/*}
FILE=$(basename "$INPUT" .scad)

echo "$THINGID -> $VERSION"

mkdir -p "$RESULTDIR/$OUTDIR"
t=$({ time $OPENSCAD "$INPUT" -o "$RESULTDIR/$OUTDIR/$FILE.png" > "$RESULTDIR/$OUTDIR/$FILE.log" 2>&1 ; } 2>&1)
if [[ $? != 0 ]]; then
    echo $? > "$RESULTDIR/$OUTDIR/$FILE-failed.txt"
fi
echo $t > "$RESULTDIR/$OUTDIR/$FILE-time.txt"
