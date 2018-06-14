#!/bin/bash

#s3 does not  sync the empty folder and automatically delete if folder is empty --need to uncomment aws s3 rm "$TGT_BUCKET_NAME"/"$DATE"/tests3_new.sh 
# script copy create the local dir and sync to s3 

echo $(date) >>start.out

DATE=$(date +%Y%m%d)
DATE_FORMAT=$(date +%Y-%m-%d)
PWD_DIR="$PWD"
SRC_LOCAL_FOLDER="$PWD_DIR/tde_athena"
SRC_BUCKET_NAME="s3://kite-clickhistory-prod"
TGT_BUCKET_NAME="s3://kite-sqlite-extracts/tmp/test/prod_test"

var_date=1
while [ $var_date -le 2 ]
do   
    DATE=$(date -d "- "$var_date" days" +%Y/%m/%d )
    DATE_FORMAT=$(date -d "- "$var_date" days" +%Y-%m-%d )
	#mkdir -p  "$PWD_DIR"/tde_athena/
	#mkdir -p  "$PWD_DIR"/tde_athena/"$DATE"
	#cp "$PWD_DIR"/tests3_new.sh "$PWD_DIR"/tde_athena/"$DATE"/
 	echo "$DATE"
 	#echo "$DATE_FORMAT"
 	#echo "$var_date"
	#aws s3 sync "$SRC_LOCAL_FOLDER"/"$DATE"/ "$TGT_BUCKET_NAME"/"$DATE"/
	for file in $( aws s3 ls "$SRC_BUCKET_NAME"/ | grep "$DATE_FORMAT" | awk '{print $4}'); do
        echo $file;
        aws s3 cp "$SRC_BUCKET_NAME"/$file "$TGT_BUCKET_NAME"/$DATE/$file >/dev/null
        done
	#aws s3 rm "$TGT_BUCKET_NAME"/"$DATE"/tests3_new.sh    
	(( var_date++ ))
done


#aws s3 ls s3://kite-clickhistory-prod --recursive | awk -F'[ ]' -v mydate="$(date +"%Y-%m-%d ")" '$1=mydate {print $1}'
#aws s3 ls s3://studentlogin-qa --recursive --human-readable --summarize | awk -F'[-: ]' '$1 = 2018 && $2 >= 1 && $2 < 2 { print $10"-"$11"-"$12"-"$13}' >> jan2018.txt
#aws s3 ls s3://clickhistory-qa --recursive --human-readable --summarize | awk -F'[-: ]' '$1 = 2018 && $2 >= 1 && $2 < 2 { print $10"-"$11"-"$12"-"$13}' >> jan2018.txt

echo $(date) >>end.out
