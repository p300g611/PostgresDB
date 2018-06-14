#Send mail Function
CPASS_RECIPIENTS=wwh8623@gmail.com
KAP_RECIPIENTS=wwh8623@gmail.com
ARMM_RECIPIENTS=wwh8623@gmail.com
ATEA_RECIPIENTS=wwh8623@gmail.com
KELPA_RECIPIENTS=wwh8623@gmail.com
EMAIL_CC_RECIPIENTS=pgopisetty@ku.edu,tao-guo@ku.edu,ginsburgs_sta@ku.edu,sdmartin@ku.edu,ats_infrastructure_dl@ku.edu
log_file="/srv/extracts/extract_sqlite_log.txt"
send_email ()
{
   echo "The $1 SQLite database failed to create." | mailx -s "$1 - SQLite Database failed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

psql -h cbdb3.prodku.cete.us -U lportal_reader -f "/srv/extracts/CETE/1_datalayout_cb.sql" -d lportal > /dev/null
psql -h aartdwdb.prodku.cete.us -U aartdw_reader -f "/srv/extracts/CETE/2_datalayout_dw.sql" -d aartdw > /dev/null
psql -h cbdb3.prodku.cete.us -U lportal_reader -f "/srv/extracts/CETE/3_datalayout_cb.sql" -d lportal > /dev/null
psql -h pg3.prodku.cete.us -U aart_user -f "/srv/extracts/CETE/upsert_taskvariantpossiblescoresjson.sql" -d aart-prod > /dev/null

python /srv/extracts/source/extract_sqlite.py -a "11" -d /srv/extracts/data/cpass.sqlite -t "all" -o -n "host='pg3.prodku.cete.us' dbname='aart-prod' user='aart_reader'"
CPASS_EXIT_STATUS=$?

# mail if failed
if [ $CPASS_EXIT_STATUS -ne 0 ]; then
   send_email CPASS $CPASS_RECIPIENTS
fi

python /srv/extracts/source/extract_sqlite.py -a "12" -d /srv/extracts/data/kap.sqlite -t "all" -o -p "Summative" -n "host='pg3.prodku.cete.us' dbname='aart-prod' user='aart_reader'"
KAP_EXIT_STATUS=$?

# mail if failed
if [ $KAP_EXIT_STATUS -ne 0 ]; then
   send_email KAP $KAP_RECIPIENTS
fi

python /srv/extracts/source/extract_sqlite.py -a "47" -d /srv/extracts/data/kelpa.sqlite -t "all" -o -p "Summative" -n "host='pg3.prodku.cete.us' dbname='aart-prod' user='aart_reader'"
KELPA_EXIT_STATUS=$?

# mail if failed
if [ $KELPA_EXIT_STATUS -ne 0 ]; then
   send_email KELPA $KELPA_RECIPIENTS
fi

# log rotate every month
if [ -f "$log_file" ] && [ "$(date +%d)" -eq 1 ] ;then
  mv $log_file /srv/extracts/extract_sqlite_log_lastmonth.txt
fi
