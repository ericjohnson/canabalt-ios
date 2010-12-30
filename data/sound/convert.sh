#!/bin/bash

AFCONVERT=afconvert

MP3S=`ls *.mp3`

FORMAT=caff
DATA_FORMAT=LEI16
SAMPLE_RATE=22050
CHANNELS=1

for MP3 in $MP3S
do
    CAF=`basename -s .mp3 $MP3`.caf
    $AFCONVERT -f $FORMAT -d ${DATA_FORMAT}@${SAMPLE_RATE} -c $CHANNELS $MP3 $CAF
done


