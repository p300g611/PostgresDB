#!/bin/bash

#aws s3 ls s3://kite-clickhistory-prod/ | grep "2018-04-03" | awk '{print $4}' >>buckets.txt

#echo $(date) >> starttodayevening.out
#for i in $(cat txts.out);
#do
#    filename=$i
#    prefixvar=$(echo $filename | cut -d '-' -f 2 | cut -c1-3)
#    aws s3 mv s3://kite-sqlite-extracts/tmp/clickhistory/102/$filename s3://kite-sqlite-extracts/tmp/clickhistory/10102/$filename > /dev/null
#done

#echo $(date) >> endtodayevening.out


#1. need to sync to local directory 
#2. create the folder 
#3. move the files
#4. re-upload with same time stamps
#5. for incremental load we need find last modified only last modified dates


#rm -r archive
#mkdir -p /home/p300g611/archive

#cd archive

#time aws s3 sync --region us-west-2 --exact-timestamps s3://kite-clickhistory-prod/ .


#/home/p300g611/archive


#commands executed 04/10/2018

#STEP1:Login to dbutil2 as aai_backup_sa and copy s3 bucket to local 

cd /srv/kiteclickhistory/history/

aws s3 sync --exact-timestamps s3://kite-clickhistory-prod/ .


#STEP2: create process file
cd /srv/kiteclickhistory/history/

rm /srv/kiteclickhistory/history/fileslist.out
#ls  >>/srv/kiteclickhistory/history/fileslist.out

ls -p | grep -v / >>/srv/kiteclickhistory/history/fileslist.out

#find the file from last 40 days 

#  find /srv/kiteclickhistory/history/ -maxdepth 1 -mtime -40 -name "*.json" | xargs -n1 basename >>fileslist.out

#ls | wc -l

#cat /srv/kiteclickhistory/history/fileslist.out |wc -l

#STEP3: create local prefix folder
##create empty local prefix folder
#!/bin/bash
for num in {0..999}; do
    prefixvar=$(echo 000$num | tail -c4)
	#mkdir -p /srv/kiteclickhistory/history
	echo $prefixvar
    mkdir -p /srv/kiteclickhistory/history/$prefixvar
done

#STEP4: ##move file to local prefix folder
#!/bin/bash
echo $(date) >> startdate.out
row_num=1
for filename in $(cat /srv/kiteclickhistory/history/fileslist.out);
do
    prefixvar=$(echo $filename | cut -d '-' -f 2 | tail -c4)
    #echo $filename
    #echo $prefixvar
    echo $row_num
	#mkdir -p /home/p300g611/archive/$prefixvar
	(( row_num++ ))
	mv /srv/kiteclickhistory/history/$filename  /srv/kiteclickhistory/history/$prefixvar/$filename	
done
echo $(date) >> enddate.out

#cd /srv/kiteclickhistory/history/

#aws s3 sync --exact-timestamps /srv/kiteclickhistory/history/000/ s3://kite-clickhistory-prod-archive/000/

#STEP5:##upload filed to archive bucket 


#!/bin/bash
echo $(date) >> startdate_new.out
for num in {0..999}; do
    prefixvar=$(echo 000$num | tail -c4)
    #mkdir -p /srv/kiteclickhistory/history
    echo $prefixvar
    #mkdir -p /srv/kiteclickhistory/history/$prefixvar
    aws s3 sync --quiet --exact-timestamps /srv/kiteclickhistory/history/$prefixvar/ s3://kite-clickhistory-prod-archive/$prefixvar/
done
echo $(date) >> enddate_new.out

