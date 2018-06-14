#!/bin/bash
#process 2018 archive upload files
for i in /srv/extracts/helpdesk/moodle/processed/upload_moodle/upload_moodle*.csv; do
  [[ -e $i ]] || break
  echo "$i --File processing"
  cp "$i" "/srv/extracts/helpdesk/moodle/processed/upload_moodle/tmp_upload_moodle_2018.csv"
  psql -h aart-qa.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_user -f "/srv/extracts/helpdesk/moodle/scripts/tmp_upload_moodle_2018.sql" aartqa
done;