##Send mail Function
DLM_RECIPIENTS=bnash@ku.edu,akclark@ku.edu,karvonen@ku.edu,marilangas@ku.edu,jakethompson@ku.edu,ats_infrastructure_dl@ku.edu
EMAIL_CC_RECIPIENTS=pgopisetty@ku.edu,tao-guo@ku.edu,shlomog@ku.edu,sdmartin@ku.edu

send_email ()
{
   echo "The $1 SQLite database failed to create." | mailx -s "$1 - SQLite Database failed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/source/extract_sqlite.py -a "3" -y "2018" -d /srv/extracts/data/dlm.am.sqlite -t "all" -n "host='aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com' dbname='aartprod' user='aart_reader'"
DLM_EXIT_STATUS=$?

# mail if failed
if [ $DLM_EXIT_STATUS -ne 0 ]; then
   send_email "DLM AM" $DLM_RECIPIENTS
   exit;
fi
cp /srv/extracts/data/dlm.am.sqlite /srv/extracts/data/dlm.am_bkup.sqlite
cp /srv/extracts/data/dlm.am_bkup.sqlite /srv/extracts/data/dlm.am_tmp.sqlite
sqlite3 /srv/extracts/data/dlm.am_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_original2017.sql
sqlite3 /srv/extracts/data/dlm.am_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_testletlevel2017.sql
sqlite3 /srv/extracts/data/dlm.am_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_survey2017.sql
sqlite3 /srv/extracts/data/dlm.am_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_survey_dcps.sql
sqlite3 /srv/extracts/data/dlm.am_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_inactive2017.sql
mv /srv/extracts/data/dlm.am_tmp.sqlite /srv/extracts/data/dlm.am.sqlite
aws s3 mv s3://kite-sqlite-extracts/data/DLM/dlm.am.sqlite s3://kite-sqlite-extracts/data/DLM/dlm.am.sqlite-old >/dev/null
aws s3 cp /srv/extracts/data/dlm.am.sqlite s3://kite-sqlite-extracts/data/DLM/dlm.am.sqlite >/dev/null