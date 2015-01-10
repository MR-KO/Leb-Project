#!/bin/bash
# Splits a .wav file into hourly long files and converts to Methlab-readable format
cd /media/kevin/DATA/vogel_audio/Recordings/c53/

declare -a files=(C53_20140618_DAY1_FAST_recFAILED.WAV C53_20140619_recstart1654_FAST_off1700_on2300_DAY2.WAV C53_20140620_recstart1721_FAST_off1700_on2300_DAY3.WAV)
outputdir=/media/kevin/DATA/vogel_audio/Recordings_fixed/c53/

numfiles=${#files[@]}

# Create the output dir if it doesnt already exist
if [ -d $outputdir ] ; then
    sleep 0
else
    mkdir -p $outputdir
fi

# Do the splitting and converting...
for ((i=0;i<$numfiles;i++)); do
    # Get length in seconds of the current file
    # length=$(sox ${files[$i]} -n stat 2>&1 | sed -n 's#^Length (seconds):[^0-9]*\([0-9.]*\)$#\1#p')

    # TODO: FIX THIS CRAP BELOW
    # for ((j=0;j<$length;j=j+3600)); do
    #     sox ${files[$i]} -e unsigned-integer $outputdir${files[$i]} trim $j 60:00
    # done
    sox ${files[$i]} -e unsigned-integer $outputdir${files[$i]}
done

echo "Done"
exit 0
