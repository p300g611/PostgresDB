#!/bin/bash

processed='/srv/extracts/scenarios/processed'
unprocessed='/srv/extracts/scenarios/unprocessed'
scripts='/srv/extracts/scenarios/scripts'
echo $processed
echo $scripts
echo $unprocessed

for i in $(ls -1R $unprocessed/|find $1 -type f); 
 do
  file_charset=$(file -bi $i)
  if [ "$file_charset" != "text/plain; charset=us-ascii" ]; then
     mv $i $i.orig
     iconv --from-code WINDOWS-1253 --to-code ASCII//TRANSLIT <$i.orig> $i
  fi
 done;

for f in $unprocessed/*;
  do 
     [ -d $f ] && cd "$f" && echo Scripts process in this location:$f 
echo "copying scenario9.sql to working locations:" 
cp $scripts/scenario9.sql $f
echo "process started for scenario9"     
     	if [ -s $f/scenario9.sql ]
            then
               echo "script scenario9.sql is available"
           	if [ -s $f/scenario9.csv ]
            		then
               			echo "File scenario9.csv processing"
                                #psql -h local -U aart_user -f "$f/scenario9.csv" -d aart-local &> "$f/scenario9.out"
        	else
               			echo "<validation> File scenario9.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario9.sql is not available"
        fi
echo "copying scenario5.sql to working locations:" 
cp $scripts/scenario5.sql $f
echo "process started for scenario5"
     	if [ -s $f/scenario5.sql ]
            then
               echo "script scenario5.sql is available"
           	if [ -s $f/scenario5.csv ]
            		then
               			echo "File scenario5.csv processing"
        	else
               			echo "<validation> File scenario5.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario5.sql is not available"
        fi
echo "copying scenario8.sql to working locations:" 
cp $scripts/scenario8.sql $f
echo "process started for scenario8"     
     	if [ -s $f/scenario8.sql ]
            then
               echo "script scenario8.sql is available"
           	if [ -s $f/scenario8.csv ]
            		then
               			echo "File scenario8.csv processing"
        	else
               			echo "<validation> File scenario8.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario8.sql is not available"
        fi
echo "copying scenario3.sql to working locations:" 
cp $scripts/scenario3.sql $f
echo "process started for scenario3"
     	if [ -s $f/scenario3.sql ]
            then
               echo "script scenario3.sql is available"
           	if [ -s $f/scenario3.csv ]
            		then
               			echo "File scenario3.csv processing"
        	else
               			echo "<validation> File scenario3.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario3.sql is not available"
        fi
echo "copying scenario4.sql to working locations:" 
cp $scripts/scenario4.sql $f
echo "process started for scenario4"     
     	if [ -s $f/scenario4.sql ]
            then
               echo "script scenario4.sql is available"
           	if [ -s $f/scenario4.csv ]
            		then
               			echo "File scenario4.csv processing"
        	else
               			echo "<validation> File scenario4.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario4.sql is not available"
        fi
echo "copying scenario2.sql to working locations:" 
cp $scripts/scenario2.sql $f
echo "process started for scenario2"
     	if [ -s $f/scenario2.sql ]
            then
               echo "script scenario2.sql is available"
           	if [ -s $f/scenario2.csv ]
            		then
               			echo "File scenario2.csv processing"
        	else
               			echo "<validation> File scenario2.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario2.sql is not available"
        fi
echo "copying scenario6.sql to working locations:" 
cp $scripts/scenario6.sql $f
echo "process started for scenario6"     
     	if [ -s $f/scenario6.sql ]
            then
               echo "script scenario6.sql is available"
           	if [ -s $f/scenario6.csv ]
            		then
               			echo "File scenario6.csv processing"
        	else
               			echo "<validation> File scenario6.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario6.sql is not available"
        fi
echo "copying scenario1.sql to working locations:" 
cp $scripts/scenario1.sql $f
echo "process started for scenario1"
     	if [ -s $f/scenario1.sql ]
            then
               echo "script scenario1.sql is available"
           	if [ -s $f/scenario1.csv ]
            		then
               			echo "File scenario1.csv processing"
        	else
               			echo "<validation> File scenario1.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario1.sql is not available"
        fi
echo "copying scenario7.sql to working locations:" 
cp $scripts/scenario7.sql $f
echo "process started for scenario7"
     	if [ -s $f/scenario7.sql ]
            then
               echo "script scenario7.sql is available"
           	if [ -s $f/scenario7.csv ]
            		then
               			echo "File scenario7.csv processing"
        	else
               			echo "<validation> File scenario7.csv not available for current day"
       		 fi
        else
               echo "<error> script scenario7.sql is not available"
        fi		
echo "moving folder to processed location"
mv $f $processed
echo "scripts executed successfully"
done;