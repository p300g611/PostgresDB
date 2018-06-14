#Send mail Function
CPASS_RECIPIENTS=pgopisetty@ku.edu
KAP_RECIPIENTS=pgopisetty@ku.edu
ARMM_RECIPIENTS=pgopisetty@ku.edu
ATEA_RECIPIENTS=pgopisetty@ku.edu
KELPA_RECIPIENTS=pgopisetty@ku.edu
EMAIL_CC_RECIPIENTS=pgopisetty@ku.edu
log_file="/srv/extracts/extract_sqlite_logt_stage.txt"
send_email ()
{
   echo "The $1 SQLite database completed." | mailx -s "$1 - SQLite Database completed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/source/extract_sqlite.py -a "47" -d /srv/extracts/data/kelpa_stage.sqlite -t "all" -o -p "Summative" -n "host='aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com' dbname='aartstage' user='aart_reader'"
KELPA_EXIT_STATUS=$?

aws s3 cp /srv/extracts/data/kelpa_stage.sqlite s3://kite-sqlite-extracts/data/KELPA/kelpa_stage_$(date +%Y%m%d).sqlite >/dev/null

send_email KELPA $KELPA_RECIPIENTS


