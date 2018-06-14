#!/bin/bash
todaydate=$(date +%Y%m%d)
DEST="/srv/extracts/helpdesk/dailyvalidation/data/DEST/dashboard"
source="/srv/extracts/helpdesk/dailyvalidation/data"
#echo "$DEST"
#echo "$source"
psql -h aartdwdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw -f "/srv/extracts/helpdesk/dailyvalidation/dailydashboard_extracts.sql" -d aartdw > /srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_extracts.csv
file_count=$(find ${DEST}/ -type f |wc -l)
if [ "${file_count}" -gt 0 ]
then
 find ${DEST}/*dailydashboard*.csv -mtime +10 -exec rm {} \;
fi
for i in $source/dailydashboard*.csv; do
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
aws s3 sync /srv/extracts/helpdesk/dailyvalidation/data/DEST s3://kite-sqlite-extracts/csv/ValidationLists/dailyvalidation --delete >/dev/null
