#!/bin/bash

REPORT_DATE=$(date --utc --date "1 day ago" +'%Y-%m-%d')

if [[ $# -eq 1 ]]; then
  REPORT_DATE=$1
fi

. /srv/aai_logs/scripts/var.sh

generate_pgbadger()
{
  AWS_INSTANCE=$1

  REPORT_PATH=${PGBADGER_REPORTS}${AWS_INSTANCE}/
  mkdir -p ${REPORT_PATH}

  # determine pgbadger report name
  REPORT_FILE=pgbadger_${AWS_INSTANCE}_${REPORT_DATE}.html
  REPORT_FILE_PATH=${REPORT_PATH}${REPORT_FILE}

  # specify logs
  LOGS=${DATA}${AWS_INSTANCE}/*${REPORT_DATE}-??
  #echo "logs variable ${LOGS}"
  # if report file doesn't exist then generate
  if [[ ! -f "${REPORT_FILE_PATH}" ]]; then
    echo "Generating ${REPORT_DATE} pgbadger report for ${AWS_INSTANCE}..."
    #   ls -l ${LOGS}
    pgbadger -p '%t:%r:%u@%d:[%p]:' ${LOGS} -o "${REPORT_FILE_PATH}"
    find ${REPORT_PATH}/pgbadger_*.html -mtime +${LOG_DAYS_TO_KEEP} -ls  -exec rm {} \;
    #aws s3 sync /srv/extracts/pgbadger/reports s3://kite-sqlite-extracts/csv/pgbadger --delete
    ${AWS} s3 sync ${REPORT_PATH} s3://agilets-pgbadger/${AWS_INSTANCE} 
  fi
}

for AWS_INSTANCE in "${AWS_INSTANCE_ALL[@]}"; do
   generate_pgbadger ${AWS_INSTANCE}
done
