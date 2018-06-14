#!/bin/bash
todaydate=$(date +%Y%m%d%H%M%S)
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu,aai_ats@ku.edu,venkat@scriptbees.com,akclark@ku.edu,bnash@ku.edu,marilangas@ku.edu,jakethompson@ku.edu

psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/dailyvalidation/dlm_testsession_counts.sql" -d aartprod > /dev/null

file_counts="/srv/extracts/helpdesk/dailyvalidation/data/dlm_testsession_counts.csv"
file_today="/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_today.csv"
file_yesterday="/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_yesterday.csv"

if [ -f "$file_today" ]
then
	 file_count=$(find "$file_today" -mtime -10 -type f |wc -l)
     if [ "${file_count}" -gt 0 ]
        then
            mv "$file_today" "$file_yesterday"
            cp "$file_counts" "$file_today"
		else 
		  cp "$file_counts" "$file_today"
		  cp "$file_counts" "$file_yesterday"
     fi
else
    cp "$file_counts" "$file_today"
    cp "$file_counts" "$file_yesterday"
fi


#echo "$todaydate process started" 
#psql -h pg1.stageku.cete.us -U aart_reader -f "/srv/extracts/helpdesk/dailyvalidation/dailyvalidation.sql" -d aart-stage &> /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out
psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/dailyvalidation/dailyvalidation.sql" -d aartprod &> /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out

sed -i '1,4d' /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out
sed -i 's/psql:\/srv\/extracts\/helpdesk\/dailyvalidation\/dailyvalidation./p/g' /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out
echo "automail" | mailx -s "daily validation on prod-proactive data sample and more details here S:\ATS_SFD\ValidationLists" $EMAIL_CC_RECIPIENTS < /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out

psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/dailyvalidation/dailyvalidation_extracts.sql" -d aartprod > /srv/extracts/helpdesk/dailyvalidation/dailyvalidation.out
sh /srv/extracts/helpdesk/dailyvalidation/dailyvalidation_extracts.sh
todaydate=$(date +%Y%m%d%H%M%S)
#echo "$todaydate process ended"


aws s3 sync /srv/extracts/helpdesk/dailyvalidation/data/DEST s3://kite-sqlite-extracts/csv/ValidationLists/dailyvalidation --delete >/dev/null

