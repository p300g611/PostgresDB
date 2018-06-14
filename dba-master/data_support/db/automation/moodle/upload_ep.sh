#!/bin/bash
file="/srv/extracts/helpdesk/moodle/upload_ep/user_training_error.csv"
processed='/srv/extracts/helpdesk/moodle/processed/upload_ep'
unprocessed='/srv/extracts/helpdesk/moodle/upload_ep'
scripts='/srv/extracts/helpdesk/moodle/scripts'

echo "$processed   --processed location"
echo "$scripts     --script location"
echo "$unprocessed --unprocessed location"

for i in $unprocessed/upload_ep*.csv; do
  [[ -e $i ]] || break
  file_charset=$(file -bi "$i")
  if [ "$file_charset" != "text/plain; charset=us-ascii" ]; then
    echo "$i file found utf-8 characters and removing"
    mv "$i" "$i.orig"
    iconv --from-code WINDOWS-1253 --to-code ASCII//TRANSLIT <"$i.orig"> "$i"
    mv "$i.orig" "$processed/"
  fi
done;

for i in $unprocessed/upload_ep*.csv; do
  [[ -e $i ]] || break
  echo "$i --File processing"
  cp "$i" "$processed/"
  mv "$i" "$unprocessed/user_training.csv"
  psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_user -f "$scripts/upload_ep.sql" aartprod &> "$i.out.prod"
    LINECOUNT=$(wc -l "$file" | cut -f1 -d' ')
    if [[ $LINECOUNT -le 1 ]]; then
      echo "$file  --Deleted empty file."
      rm -f $file
    else
      mv $file "$i.error.out.prod"
    fi
   mv $unprocessed/*.out.prod "$processed/"
   mv "$unprocessed/user_training.csv" "$processed/"
done;

