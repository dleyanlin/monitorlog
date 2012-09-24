#!/bin/bash
#version 1.0
#2012-05-14

EMAILADDRESS="psoqa3@hzlab.qa.webex.com"
EMAILSUBJECT="***** We've got a problem *****"
MESSAGEBODY="/home/psoqa/error.txt"
SEARCHSTRING='2994'
PSOLOG="/wbx_log/pso-test.log"

cat /dev/null > $MESSAGEBODY

LASTOCCURANCE=`egrep -n "$SEARCHSTRING" $PSOLOG | tail -1`
LASTLINE=`echo $LASTOCCURANCE | cut -d':' -f1`

while true
do

END=`wc -l $PSOLOG | cut -d' ' -f1`
if [ $END -lt $LASTLINE ]
then
  LASTLINE=$END
fi
#echo $LASTLINE
tail -n +$LASTLINE $PSOLOG | grep -C $LASTLINE "$SEARCHSTRING" > $MESSAGEBODY

if [ `stat -c %s $MESSAGEBODY` -ne '0' -a $LASTLINE -ne $END ]
then
  echo "We have an above problem, please check." >> $MESSAGEBODY
  mail -s "$EMAILSUBJECT" "$EMAILADDRESS" < $MESSAGEBODY
  cat /dev/null > $MESSAGEBODY
  ((LASTLINE=$LASTLINE+1))

fi
LASTLINE=$END
cat /dev/null > $MESSAGEBODY
rm -rf $MESSAGEBODY 
sleep 5

done