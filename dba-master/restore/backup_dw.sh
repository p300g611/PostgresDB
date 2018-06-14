#!/bin/bash
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate backup process started"
db_status="notavailable"
row_num=1

send_email ()
{
   echo "The $1 "$todaydate"." | mailx -s "DW DATABASE" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

aws rds restore-db-instance-to-point-in-time --region us-east-1 --availability-zone us-east-1b --source-db-instance-identifier aartdwdb-stage --target-db-instance-identifier aartdwdb-stage-temp --use-latest-restorable-time --no-publicly-accessible --db-subnet-group-name kite-stage-db-subnet-group --db-instance-class db.t2.medium 

while [ $db_status != "available" ]
do  
    echo "Number of times loop running:$row_num"
	db_status=$(aws rds describe-db-instances --region us-east-1 --db-instance-identifier aartdwdb-stage-temp --query 'DBInstances[*].[DBInstanceStatus]' --output text)
	echo "$db_status"
	sleep 10m
	(( row_num++ ))
done

aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartdwdb-stage-temp --vpc-security-group-ids sg-7151d003 --backup-retention-period 2 --apply-immediately

## old back remove two lines 

aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartdwdb-stage-temp --new-db-instance-identifier aartdwdb-stage-temp2 --apply-immediately

todaydate=$(date +%Y%m%d%H%M%S)
send_email restore_completed $EMAIL_CC_RECIPIENTS
echo "$todaydate restore process completed"