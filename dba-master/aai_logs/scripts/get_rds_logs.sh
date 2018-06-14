#!/bin/bash

if [[ $# -ne 4 ]]; then
  echo "USAGE ERROR: $0 <region> <instance_name> <from_hours_back> <to_hours_back>"
  echo
  echo "  e.g. $0  us-east-1  aartdb-prod  1  24"
  echo
  echo "       would pull the logs from us-east-1.aartdb-prod for the last 24 hours"
  echo
  exit -1
fi

. /srv/aai_logs/scripts/var.sh

AWS_REGION=$1
RDS_INSTANCE=$2
FROM_HOURS=$3
TO_HOURS=$4

LOGS_PATH=${DATA}${RDS_INSTANCE}/
mkdir -p "${LOGS_PATH}"

get_log()
{
  HOURS_BACK=$1
  #echo "HOURS_BACK ${HOURS_BACK}"

  LOG_TIME=$(date --utc --date "${HOURS_BACK} hours ago" +'%Y-%m-%d-%H')
  #echo "LOG_TIME ${LOG_TIME}"
  AWS_LOG_NAME=${AWS_LOG_BASE}${LOG_TIME}
  LOG_NAME=${LOG_BASE}${LOG_TIME}

  echo "Getting log for ${AWS_REGION} - ${RDS_INSTANCE} ($HOURS_BACK hours ago)"
  find ${LOGS_PATH} -name "postgresql.log.*" -mtime +${LOG_DAYS_TO_KEEP} -ls -exec rm {} \;
  # ${AWS} rds download-db-log-file-portion --db-instance-identifier "${RDS_INSTANCE}" --region "${AWS_REGION}" --log-file-name "${AWS_LOG_NAME}" --output=text > "${LOGS_PATH}${LOG_NAME}"
  ${SCRIPTS}get_full_rds_log.sh ${AWS_REGION} ${RDS_INSTANCE} ${LOG_NAME}
}

for HOURS_BACK in `seq $FROM_HOURS $TO_HOURS`; do
  get_log $HOURS_BACK
done

# sync logs to S3
RDS_INSTANCE_ARN="arn:aws:rds:${AWS_REGION}:${AWS_ACCT_ID}:db:${RDS_INSTANCE}"

STACK_TAG=$(${AWS} rds list-tags-for-resource --resource-name ${RDS_INSTANCE_ARN} --region ${AWS_REGION} --output text | grep stack | awk '{print $3}')
#echo "${STACK_TAG}"
if [[ "${STACK_TAG}" = "production" ]];
then
    ${AWS} s3 sync ${DATA}${RDS_INSTANCE} s3://kite-logs-prod/rds/${RDS_INSTANCE}
else
    ${AWS} s3 sync ${DATA}${RDS_INSTANCE} s3://kite-logs-${STACK_TAG}/rds/${RDS_INSTANCE}
fi





