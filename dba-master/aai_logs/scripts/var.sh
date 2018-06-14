#!/bin/bash

# paths
HOME=/srv/aai_logs/
DATA=${HOME}data/
SCRIPTS=${HOME}scripts/
SCRIPT_WORK=${SCRIPTS}work/
SCRIPT_LOGS=${HOME}logs/
PGBADGER_REPORTS=${HOME}pgbadger/
AWS=/usr/local/bin/aws

# RDS log file name
LOG_TYPE="error"
LOG_BASE="postgresql.log."
AWS_LOG_BASE="${LOG_TYPE}/${LOG_BASE}"
LOCAL_LOG_BASE="${LOG_BASE}"

# How long to keep logs (in days)
LOG_DAYS_TO_KEEP=8

# AWS detail
AWS_ACCT_ID="013542324422"
AWS_REGION="us-east-1"

# RDS instances
## AWS_INSTANCE_ALL=($(aws rds describe-db-instances --region us-east-1 | grep 'DBInstanceIdentifier"' | awk '{print $2}'))
AWS_INSTANCE_ALL=("aartdb-prod" "aartauditdb-prod" "aartdwdb-prod" "cbdb-prod" "aartdb-stage" "aartauditdb-stage" "aartdwdb-stage" "cbdb-stage" "aart-qa" "aartdwdb-qa" "cbdb-qa")

