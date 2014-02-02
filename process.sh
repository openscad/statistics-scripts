#
# Usage: process.sh [-v] <type> <version> <inputfile.scad> <outputfile.png>
#        -v    Verbose output
#
#        type: preview or render (render passes --render to OpenSCAD)
#        version: OpenSCAD version must match filename of OpenSCAD-<version>.app
#

# Use -v flag to enable debug mode
while getopts 'vr' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

TYPE=$1
VERSION=$2
INPUT=$3
OUTPUT=$4

OPENSCAD=/Users/kintel/Desktop/OpenSCAD-$VERSION.app/Contents/MacOS/OpenSCAD 
export OPENSCADPATH=$PWD/customizer-libraries
export TIMEFORMAT='%1U'

if [[ $TYPE == "render" ]]; then
  RENDER=--render
else
  RENDER=
fi

OUTPUTDIR=$(dirname "$OUTPUT")
INPUTDIR=$(dirname "$INPUT")
FILEPATH=${INPUTDIR#unpacked/}   # Strip away unpacked/, leaving <thingid>/...
THINGID=${FILEPATH%%/*}
FILE=$(basename "$INPUT" .scad)
if [ $RENDER ]; then
  TIMEOUT=3600
else
  TIMEOUT=1000
fi

echo "$THINGID -> $VERSION"

mkdir -p "$OUTPUTDIR"
t=$({ time timeout $TIMEOUT $OPENSCAD "$INPUT" -o "$OUTPUT" $RENDER > "$OUTPUTDIR/$FILE.log" 2>&1 ; } 2>&1)
retval=$?
if [[ $retval != 0 ]]; then
    echo $retval > "$OUTPUTDIR/$FILE-failed.txt"
    if [[ $retval == 137 ]]; then
        echo $THINGID >> killed-$TYPE-$VERSION.txt
    fi
fi
echo $t > "$OUTPUTDIR/$FILE-time.txt"

if [ ! -s $OUTPUT ]; then
  touch $OUTPUT
fi
