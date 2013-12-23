#!/bin/bash
#version 1.1
#2012-05-14

EMAILADDRESS="xxx@xx.com"
EMAILSUBJECT="***** We've got a problem *****"
MESSAGEBODY="errot_path/error.txt"
SEARCHSTRING='string'
LOGPATH="/log_path/xxx.log"

cat /dev/null > $MESSAGEBODY

LASTOCCURANCE=`egrep -n "$SEARCHSTRING" $LOGPATH | tail -1`
LASTLINE=`echo $LASTOCCURANCE | cut -d':' -f1`

while true
do

END=`wc -l $LOGPATH | cut -d' ' -f1`
if [ $END -lt $LASTLINE ]
then
  LASTLINE=$END
fi
#echo $LASTLINE
tail -n +$LASTLINE $LOGPATH | grep -C $LASTLINE "$SEARCHSTRING" > $MESSAGEBODY

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
