#!/bin/bash
todaydate=$(date +%Y%m%d%H%M%S)
file="/srv/extracts/helpdesk/moodle/processed/upload_moodle/tmp_upload_moodle.csv"
export='/srv/extracts/helpdesk/moodle/processed/upload_moodle'
scripts='/srv/extracts/helpdesk/moodle/scripts'
statefile='/srv/extracts/helpdesk/moodle/state_roles'

echo "$todaydate  --Processing time"
echo "$export     --Upload destination"
echo "$scripts    --Script location"
echo "$statefile  --Satefile"

for i in $statefile/state_roles.csv; do
  [[ -e $i ]] || break
  file_charset=$(file -bi $i)
  if [ "$file_charset" != "text/plain; charset=us-ascii" ]; then
     echo "$i file found utf-8 characters and removing" 
     mv $i $i.orig
  iconv --from-code WINDOWS-1253 --to-code ASCII//TRANSLIT <$i.orig> $i
  mv "$i.orig" "$statefile/" 
  fi
 done;

psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_user -f "$scripts/upload_moodle.sql" -d aartprod &> $scripts/upload_moodle.out

if [ -f "$file" ]
then
	LINECOUNT=$(wc -l $file | cut -f1 -d' ')
	if [[ $LINECOUNT -le 1 ]]; then
           echo "$file  --Deleted empty file."
           rm -f $file
        else
        mv "$file" "$export/upload_moodle_$todaydate.csv"   
        fi
else
	echo "$file  --File not found."
fi

sftp -o IdentityFile=~/.ssh/ku-upload.key ku-upload@ku.rms.webanywhere.co.uk <<EOF
  mput $export/upload_moodle_$todaydate.csv /live/incoming/
  bye
EOF
