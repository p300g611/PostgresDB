#!/bin/bash

#aws s3 ls s3://kite-clickhistory-prod/ | grep "2018-04-03" | awk '{print $4}' >>buckets.txt

echo $(date) >> starttodayevening.out
for i in $(cat buckets.txt);
do
    filename=$i
    prefixvar=$(echo $filename | cut -d '-' -f 2 | cut -c1-3)
    aws s3 cp s3://kite-clickhistory-prod/$filename s3://kite-sqlite-extracts/tmp/clickhistory/$prefixvar/$filename > /dev/null
done

echo $(date) >> endtodayevening.out


aws s3 sync s3://kite-clickhistory-stage/  s3://kite-sqlite-extracts/tmp/345/   --exclude '*.json' --include '*345-*.json' --exclude '*345-click.json'


aws s3 sync s3:://kite-sqlite-extracts/tmp/345/  s3:://kite-sqlite-extracts/tmp/346/   --exclude '*.json' --include '*345-*.json' --exclude '*345-click.json'

aws s3 cp --recursive --exclude '*' --include '2016-11-16-17*' s3://bucket/logs/ .


aws s3 cp s3://kite-clickhistory-prod/  s3://kite-sqlite-extracts/tmp/367/ --recursive --exclude "*" --include "*367-*.json" --exclude "*367-click.json"

aws s3 sync s3://kite-clickhistory-prod-west/ s3://kite-clickhistory-prod-archivewest/

aws s3 mv s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/100/ --recursive --exclude "*" --include "*100-*.json" --exclude "*100-click.json"
aws s3 mv s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/000/ --recursive --exclude "*" --include "*000-*.json" --exclude "*000-click.json"


//kite-clickhistory-prod-archivewest/1qQbbKO-1290100-32716414-click.json

aws s3 ls s3://BUCKETNAME --recursive | awk '{total+=$3} END{print "total =",total/1024/1024," MB"}'



0000P8u-256630-32101710-click.json 

aws s3 mv s3://kite-clickhistory-prod-archivewest/0000P8u-256630-32101710-click.json s3://kite-clickhistory-prod-archivewest/000/delete_0000P8u-256630-32101710-click.json

#sync entire bucket around 40gb  6 hr 
aws s3 sync s3://kite-clickhistory-prod-west/ s3://kite-clickhistory-prod-archivewest/

#for move we do not need to create folder 
time aws s3 mv   s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/000/ --recursive --exclude "*" --include "*000-*.json" --exclude "*000-click.json" --exclude "000/*"
time aws s3 mv   s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/000/ --recursive --exclude "*" --include "*000-*.json" --exclude "*000-click.json" --exclude "001/*"
time aws s3 mv   s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/001/ --recursive --exclude "*" --include "*001-*.json" --exclude "*00-click.json"
time aws s3 mv   s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/002/ --recursive --exclude "*" --include "*002-*.json" --exclude "*002-click.json"
time aws s3 mv   s3://kite-clickhistory-prod-archivewest/001/001/ s3://kite-clickhistory-prod-archivewest/001/ --recursive --exclude "*" --include "*001-*.json" --exclude "*001-click.json"

#for sync we do need to create folder ( but might working some time need to tested)
time aws s3 sync s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/001/   --exclude "*" --include "*001-*.json" --exclude "*001-click.json" --exclude "001/*"
time aws s3 sync s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/001/   --exclude '001/*'  --exclude "*" --include "*001-*.json" --exclude "*001-click.json"
time aws s3 sync s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/001/   --exclude '001/*'  --exclude "*" --include "*001-*.json" --exclude "*001-click.json"
time aws s3 sync s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/100/             --exclude "*" --include "*100-*.json" --exclude "*100-click.json"


time aws s3 sync --region us-west-2 --exact-timestamps s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/004/  --exclude "*" --include "*004-*.json" --exclude "*004-click.json" --exclude "004/*"
time aws s3 sync --region us-west-2 --exact-timestamps s3://kite-clickhistory-prod-archivewest/ s3://kite-clickhistory-prod-archivewest/201/  -include "*201-*.json" --exclude "*201-click.json" --exclude "201/*"


time aws s3 sync --region us-west-2 --exact-timestamps s3://kite-clickhistory-prod-archivewest/ .  



time aws s3 mv s3://kite-clickhistory-prod-archivewest/000/000/* s3://kite-clickhistory-prod-archivewest/000/ --recursive 


--quiet


--region ${REGION} s3 sync --quiet --exact-timestamps


















