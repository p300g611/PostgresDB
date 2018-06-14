##Send mail Function
PNP_RECIPIENTS=ats_dba_team@ku.edu
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu

send_email ()
{
   echo "The $1 SQLite database failed to create." | mailx -s "$1 - SQLite Database failed" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

python /srv/extracts/source/pnp_extract.py -a "3" -y "2018" -d /srv/extracts/pnpdata/pnp.sqlite -t "all" -n "host='pg3.prodku.cete.us' dbname='aart-prod' user='aart_reader'"
PNP_EXIT_STATUS=$?

# mail if failed
if [ $PNP_EXIT_STATUS -ne 0 ]; then
   send_email "PNP extract" $PNP_RECIPIENTS
   exit;
fi

mv /srv/extracts/pnpdata/pnp_ReadOnlyFolder/pnp_extract.csv /srv/extracts/pnpdata/pnp_ReadOnlyFolder/pnp_extract_old.csv
sqlite3 -header -csv /srv/extracts/pnpdata/pnp.sqlite "select * from pnpextract order by State;" > /srv/extracts/pnpdata/pnp_ReadOnlyFolder/pnp_extract.csv

#crontab
#35 18 * * SUN /srv/extracts/source/pnp_extract.sh