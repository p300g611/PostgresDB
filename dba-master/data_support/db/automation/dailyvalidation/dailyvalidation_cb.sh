#!/bin/bash
todaydate=$(date +%Y%m%d%H%M%S)
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu,aai_ats@ku.edu
#echo "$todaydate process started" 
psql -h cbdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal_reader -f "/srv/extracts/helpdesk/dailyvalidation/dailyvalidation_cb.sql" -d lportal &> /srv/extracts/helpdesk/dailyvalidation/dailyvalidation_cb.out
sed -i 's/psql:\/srv\/extracts\/helpdesk\/dailyvalidation\/dailyvalidation_cb./p/g' /srv/extracts/helpdesk/dailyvalidation/dailyvalidation_cb.out
echo "automail" | mailx -s "daily CB validation on prod-proactive data" $EMAIL_CC_RECIPIENTS < /srv/extracts/helpdesk/dailyvalidation/dailyvalidation_cb.out
todaydate=$(date +%Y%m%d%H%M%S)
#echo "$todaydate process ended"




