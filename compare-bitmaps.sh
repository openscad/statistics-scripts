#!/bin/sh


while getopts 'v' c
do
  case $c in
    v) set -x ;;
  esac
done
shift $(($OPTIND - 1))

baseimage=$1
shift

for arg in $@; do
  # FIXME: Sometimes, compare fails when comparing very small images (e.g. 40 x 10 pixels).
  # It's unknown why this happens..
  #pixelerror=`compare -fuzz 10% -metric AE $1 $2 null: 2>&1`
  pixelerror=$(convert $baseimage $arg -alpha Off -compose difference -composite -threshold 10% -morphology Erode Square -format "%[fx:w*h*mean]" info:)
  
  if [ $? -ne 0 ]; then
      echo "General error: Ouch"
      exit 1 # Compare failed to read image
  else
      # Check if $pixelerror contains an integer (it sometimes outputs things like '0 @ 0,0')
      if [ $pixelerror -eq $pixelerror 2> /dev/null ]; then
          if [ $pixelerror -lt 100 ]; then 
              continue
          fi
          echo "Pixel error: $pixelerror"
      else
          echo "Pixel error: Err"
      fi
      exit 1
  fi
done
exit 0
