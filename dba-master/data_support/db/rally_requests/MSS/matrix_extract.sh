#Send mail Function
MSS_RECIPIENTS=ats_dba_team@ku.edu
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu
send_email ()
{
   echo "The $1 SQLite database failed to create." | mailx -s "$1 - SQLite Database failed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/helpdesk/rally_requests/MSS/matrix_extract.py -a "49" -d /srv/extracts/helpdesk/rally_requests/MSS/mss_matrix.sqlite -t "matrix" -o -p "Summative" -n "host='pg3.prodku.cete.us' dbname='aart-prod' user='aart_reader'"
MSS_EXIT_STATUS=$?

# mail if failed
if [ $MSS_EXIT_STATUS -ne 0 ]; then
   send_email "MSS Matrix" $MSS_RECIPIENTS
   exit;
fi

sqlite3 -header -csv /srv/extracts/helpdesk/rally_requests/MSS/mss_matrix.sqlite < /srv/extracts/helpdesk/rally_requests/MSS/mss_matrix_extract.sql > /srv/extracts/helpdesk/rally_requests/MSS/mss_students_responses_survey.csv
psql -h pg3.prodku.cete.us -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/MSS/mss_students_tests.sql" -d aart-prod > /srv/extracts/helpdesk/rally_requests/MSS/mss_students_tests.out
psql -h pg3.prodku.cete.us -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/MSS/mss_students_responses_scores.sql" -d aart-prod > /srv/extracts/helpdesk/rally_requests/MSS/mss_students_responses_scores.out
