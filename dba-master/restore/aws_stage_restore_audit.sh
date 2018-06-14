#!/bin/bash
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate backup process started"
db_status="notavailable"
row_num=1

send_email ()
{
   echo "The $1 "$todaydate"." | mailx -s "AUDIT DATABASE" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

aws rds restore-db-instance-to-point-in-time --region us-east-1 --availability-zone us-east-1b --source-db-instance-identifier aartauditdb-prod --target-db-instance-identifier aartauditdb-stage-temp --use-latest-restorable-time --no-publicly-accessible --db-subnet-group-name kite-stage-db-subnet-group --db-instance-class db.m4.xlarge

while [ $db_status != "available" ]
do  
    echo "Number of times loop running:$row_num"
	db_status=$(aws rds describe-db-instances --region us-east-1 --db-instance-identifier aartauditdb-stage-temp --query 'DBInstances[*].[DBInstanceStatus]' --output text)
	echo "$db_status"
	sleep 5m
	(( row_num++ ))
done

aws rds wait db-instance-available --region us-east-1 --db-instance-identifier aartauditdb-stage-temp

aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartauditdb-stage-temp --vpc-security-group-ids sg-7151d003 --backup-retention-period 2 --apply-immediately

aws rds delete-db-instance --region us-east-1 --db-instance-identifier aartauditdb-stage --skip-final-snapshot

aws rds wait db-instance-deleted --region us-east-1 --db-instance-identifier aartauditdb-stage

aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartauditdb-stage-temp --new-db-instance-identifier aartauditdb-stage --apply-immediately

todaydate=$(date +%Y%m%d%H%M%S)
send_email restore_completed $EMAIL_CC_RECIPIENTS
echo "$todaydate restore process completed"