#!/bin/bash
# let's put  date in a variable
TODAY=`/bin/date +\%Y-\%m-\%d`
YESTERDAY=`/bin/date -d "2 day ago" +\%Y-\%m-\%d`
AWS_INSTANCE="aartdb-stage"
AWS_REGION="us-east-1"


for filename  in $(aws rds describe-db-log-files --db-instance-identifier aartdwdb-stage --region us-east-1 |awk {'print $2'}|grep $YESTERDAY)
do
 #$filename_n=$filename 
 filename_log=$(echo $filename | sed  's/,//' | sed  's/"//' | sed 's/"//') 
 #filename_logs=$(echo $filename_log | sed  's/"//' | sed 's/"//') 
 #filename_logss=$(echo $filename_logs | sed  's/"//') 
 filename_out=$(echo $filename_log | sed  's/\//_/' | sed  's/"//' | sed 's/"//') 
  echo $filename
 #echo $filename_log
 #echo $filename_out
 #aws rds download-db-log-file-portion --db-instance-identifier aartdwdb-stage --region us-east-1 --no-paginate --log-file-name $filename_log > ${filename_out}
 aws rds download-db-log-file-portion --db-instance-identifier aartdwdb-stage --region us-east-1 --log-file-name $filename_log --starting-token 0 --max-items 99999999999 --output=text > ${filename_out}
done
pgbadger -p '%t:%r:%u@%d:[%p]:' *postgresql* -o pgbader_stage.log.html
