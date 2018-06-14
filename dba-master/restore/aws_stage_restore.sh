#!/bin/bash
EMAIL_CC_RECIPIENTS=ats_dba_team@ku.edu

todaydate=$(date +%Y%m%d%H%M%S)
echo "$todaydate backup process started"


send_email ()
{
   echo "The $1 "$todaydate"." | mailx -s "TEST DATABASE" -c "$EMAIL_CC_RECIPIENTS" "$2" 
}

aws rds delete-db-instance --region us-east-1 --db-instance-identifier test3 --skip-final-snapshot

aws rds wait db-instance-deleted --region us-east-1 --db-instance-identifier test3

aws rds restore-db-instance-to-point-in-time --region us-east-1 --availability-zone us-east-1b --source-db-instance-identifier cbdb-stage --target-db-instance-identifier test3 --use-latest-restorable-time --no-publicly-accessible --db-subnet-group-name kite-stage-db-subnet-group --db-instance-class db.t2.medium

aws rds wait db-instance-available --region us-east-1 --db-instance-identifier test3

aws rds modify-db-instance --region us-east-1 --db-instance-identifier test3 --vpc-security-group-ids sg-7151d003 --backup-retention-period 2 --apply-immediately

todaydate=$(date +%Y%m%d%H%M%S)
send_email restore_completed $EMAIL_CC_RECIPIENTS
echo "$todaydate restore process completed"