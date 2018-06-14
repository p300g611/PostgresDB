#Send mail Function
EMAIL_CC_RECIPIENTS=pgopisetty@ku.edu

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate process started"

send_email ()
{
   echo "The $1 SQLite stage notification "$EXIT_STATUS"." | mailx -s "$1 - SQLite Database" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/source/extract_sqlite.py -a "12" -d /srv/extracts/data/kap_stage.sqlite -t "all" -o -p "Summative" -n "host='aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com' dbname='aartstage' user='aart_reader'"
KAP_EXIT_STATUS=$?

aws s3 cp /srv/extracts/data/kap_stage.sqlite s3://kite-sqlite-extracts/data/KAP/kap_stage_$(date +%Y%m%d).sqlite


send_email SQLite_Stage_RUN $EMAIL_CC_RECIPIENTS

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate process ended"