#!/bin/bash
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate backup process started"
db_ststus=1
row_num=1

send_email ()
{
   echo "The $1 "$todaydate"." | mailx -s "TEST DATABASE" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

while [ $db_ststus -ne 0 ]
do  
        echo "Number of times loop running:$row_num"
	psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname = 'lportal';"
        psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d postgres -c "DROP DATABASE IF EXISTS lportal;"
	db_ststus=$(psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d postgres -t -c "select case when count(*)=1 then 1 else 0 end from pg_database where datname = 'lportal';")
	sleep 1
	(( row_num++ ))
done

send_email backup_started $EMAIL_CC_RECIPIENTS
pg_dump -v -Fc -f /srv/aai_backup_data/upload/test3-`date +"%Y%m%d"`.sqlc -v -h  test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal 

todaydate=$(date +%Y%m%d%H%M%S)
send_email restore_started $EMAIL_CC_RECIPIENTS

psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "CREATE DATABASE pre_lportal OWNER agilets;"
psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER  DATABASE pre_lportal OWNER TO lportal;"
pg_restore -v -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d pre_lportal /srv/aai_backup_data/upload/test3-`date +"%Y%m%d"`.sqlc

psql -h test3.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER  DATABASE pre_lportal RENAME TO lportal;"

todaydate=$(date +%Y%m%d%H%M%S)
send_email restore_completed $EMAIL_CC_RECIPIENTS

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate backup  process ended"


