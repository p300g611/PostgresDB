#!/bin/bash 

# based on script from: https://github.com/aws/aws-cli/issues/2268

. /srv/aai_logs/scripts/var.sh

if [[ $# -ne 3 ]]; then
  echo "USAGE ERROR: $0 <region> <db-instance> <log-file-name>"
  exit -1
fi

REGION=$1
DB_INSTANCE=$2
FILE=$3

#REGION=us-east-1
#DB_INSTANCE=aartdb-prod

COUNTER=1
LASTFOUNDTOKEN=0
PREVIOUSTOKEN=0

cd ${SCRIPT_WORK}

if [ -f ${FILE} ]; then
  echo "Removing existing file."
  rm -f ${FILE}
fi

while [  $COUNTER -lt 100 ]; do
	echo "Lets try and get ${FILE}.${COUNTER}"
	echo "The starting-token will be set to ${LASTFOUNDTOKEN}"
	PREVIOUSTOKEN=${LASTFOUNDTOKEN}
	
	${AWS} rds download-db-log-file-portion --region ${REGION} --db-instance-identifier ${DB_INSTANCE} --log-file-name error/${FILE} --starting-token ${LASTFOUNDTOKEN}  --debug --output text 2>>${FILE}.${COUNTER}.debug >> ${FILE}.${COUNTER}
	LASTFOUNDTOKEN=`grep "<Marker>" ${FILE}.${COUNTER}.debug | tail -1 | tr -d "<Marker>" | tr -d "/" | tr -d " "`
	
	echo "LASTFOUNDTOKEN is ${LASTFOUNDTOKEN}"
	echo "PREVIOUSTOKEN is ${PREVIOUSTOKEN}"
	
	if [ ${PREVIOUSTOKEN} == ${LASTFOUNDTOKEN} ]; then
		echo "No more new markers, exiting"
		rm -f ${FILE}.${COUNTER}.debug
		rm -f ${FILE}.${COUNTER}
		mv ${FILE} ${DATA}${DB_INSTANCE}/
		exit;
	else
		echo "Marker is ${LASTFOUNDTOKEN} more to come ... "
		echo " "
		rm -f ${FILE}.${COUNTER}.debug
		PREVIOUSTOKEN=${LASTFOUNDTOKEN}
	fi
	
	cat ${FILE}.${COUNTER} >> ${FILE}
	rm -f ${FILE}.${COUNTER}
	
	let COUNTER=COUNTER+1
done

