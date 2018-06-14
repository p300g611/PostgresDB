#!/bin/bash
# let's put  date in a variable
TODAY=$(/bin/date +\%Y-\%m-\%d)
YESTERDAY=$(/bin/date -d "1 day ago" +\%Y-\%m-\%d)

# pgbadger home
PGBADGER_HOME=/srv/extracts/pgbadger/
PGBADGER_REPORTS=/srv/extracts/pgbadger/reports/
AWS_INSTANCE_ALL=("aartdb-prod" "aartauditdb-prod" "aartdwdb-prod" "cbdb-prod" "aartdb-stage" "aartauditdb-stage" "aartdwdb-stage" "cbdb-stage" "aart-qa" "aartdwdb-qa" "cbdb-qa")
AWS_REGION="us-east-1"

for AWS_INSTANCE in "${AWS_INSTANCE_ALL[@]}"
do
    :
    echo "${AWS_INSTANCE}"
	mkdir -p "${PGBADGER_HOME}"
    mkdir -p "${PGBADGER_HOME}"/"${AWS_INSTANCE}" 
	for filename  in $(aws rds describe-db-log-files --db-instance-identifier "${AWS_INSTANCE}" --region "${AWS_REGION}" |awk {'print $2'}|grep "${YESTERDAY}")
    do
	  filename_log=$(echo "${filename}" | sed  's/,//' | sed  's/"//' | sed 's/"//')
	  filename_out=$(echo "${filename_log}" | sed  's/\//_/' | sed  's/"//' | sed 's/"//')
	  #echo "${filename}"
	  aws rds download-db-log-file-portion --db-instance-identifier "${AWS_INSTANCE}" --region "${AWS_REGION}" --log-file-name "${filename_log}" --starting-token 0 --max-items 99999999999 --output=text > "${PGBADGER_HOME}"/"${AWS_INSTANCE}"/pgbaderlog_"${filename_out}"
    done
    pgbadger -p '%t:%r:%u@%d:[%p]:' "${PGBADGER_HOME}"/"${AWS_INSTANCE}"/pgbaderlog_* -o "${PGBADGER_REPORTS}"/"${AWS_INSTANCE}"_"${YESTERDAY}".log.html
    rm -f "${PGBADGER_HOME}"/"${AWS_INSTANCE}"/pgbaderlog_*
done


aws s3 sync /srv/extracts/pgbadger/reports s3://kite-sqlite-extracts/csv/pgbadger >/dev/null
find /srv/extracts/pgbadger/reports/*log.html -mtime +30 -ls  -exec rm {} \;
