#!/bin/bash
todaydate=$(date +%Y%m%d)
DEST="/srv/extracts/helpdesk/dailyvalidation/data/DEST"
archive="/srv/extracts/helpdesk/dailyvalidation/archive"
source="/srv/extracts/helpdesk/dailyvalidation/data"
#echo "$DEST"
#echo "$source"
file_count=$(find ${DEST}/ -type f |wc -l)
if [ "${file_count}" -gt 1 ]
then
 find ${DEST}/*dailyvalidation*.csv -mtime +10 -exec rm {} \;
fi

for i in $source/dailyvalidation*.csv; do
 # echo "$i"
  LINECOUNT=$(wc -l "${i}" | cut -f1 -d' ')
  if [[ $LINECOUNT -gt 1 ]];then
   # echo "$i"
    #echo "$DEST"
    #echo "$LINECOUNT"
    file=$(basename "${i}")
    #echo "$file"
    cp "${i}" "${DEST}/${todaydate}_${file}"
  fi
done

for i in $archive/dailyvalidation*.csv; do
 # echo "$i"
  LINECOUNT=$(wc -l "${i}" | cut -f1 -d' ')
  if [[ $LINECOUNT -gt 1 ]];then
   # echo "$i"
    #echo "$DEST"
    #echo "$LINECOUNT"
    file=$(basename "${i}")
    #echo "$file"
    cp "${i}" "${archive}/${todaydate}_${file}"
  fi
done
