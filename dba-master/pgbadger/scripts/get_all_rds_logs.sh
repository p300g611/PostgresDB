#!/bin/bash

. /srv/aai_logs/scripts/var.sh

FROM_HOUR=1
THRU_HOUR=1

if [[ $1 = "ALL" ]]; then
  THRU_HOUR=48
fi

# gather logs for each instance
for AWS_INSTANCE in "${AWS_INSTANCE_ALL[@]}"; do
    ${SCRIPTS}get_rds_logs.sh ${AWS_REGION} ${AWS_INSTANCE} ${FROM_HOUR} ${THRU_HOUR}
done
