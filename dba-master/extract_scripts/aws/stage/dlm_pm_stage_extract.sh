#Send mail Function#
DLM_RECIPIENTS=pgopisetty@ku.edu
EMAIL_CC_RECIPIENTS=pgopisetty@ku.edu
send_email ()
{
   echo "The $1 SQLite database failed to create." | mailx -s "$1 - SQLite Database failed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/source/extract_sqlite_stage.py -a "3" -y "2018"  -d /srv/extracts/extract_stage/source_stage/dlm_stage.pm.sqlite -t "all"  -n "host='aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com' dbname='aartstage' user='aart_reader'"
DLM_EXIT_STATUS=$?

# mail if failed
if [ $DLM_EXIT_STATUS -ne 0 ]; then
   send_email "DLM PM" $DLM_RECIPIENTS
   exit;
fi
cp /srv/extracts/extract_stage/source_stage/dlm_stage.pm.sqlite /srv/extracts/extract_stage/source_stage/dlm_stage.pm_bkup.sqlite
cp /srv/extracts/extract_stage/source_stage/dlm_stage.pm_bkup.sqlite /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite
sqlite3 /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_original2017.sql
sqlite3 /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_testletlevel2017.sql
sqlite3 /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_survey2017.sql
sqlite3 /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_survey_dcps.sql
sqlite3 /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite < /srv/extracts/helpdesk/rally_requests/DLM_SQLITE/masterpull_query_inactive2017.sql
mv /srv/extracts/extract_stage/source_stage/dlm_stage.pm_tmp.sqlite /srv/extracts/extract_stage/source_stage/dlm_stage.pm.sqlite