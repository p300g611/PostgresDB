#!/bin/bash

processed='/CETE_GENERAL/Technology/helpdesk/scenarios/processed'
unprocessed='/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed'
#scripts='/home/p300g611/scenarios/unprocessed/scripts'
echo $processed
echo $scripts
echo $unprocessed

for i in $(ls -1 $unprocessed/*@option.ScriptName@.csv); 
 do
  file_charset=$(file -bi $i)
  if [ "$file_charset" != "text/plain; charset=us-ascii" ]; then
     echo "file found utf-8 characters and removing"
     mv $i $i.orig
  iconv --from-code WINDOWS-1253 --to-code ASCII//TRANSLIT <$i.orig> $i
  mv $i.orig $processed/
 
  fi
 done;
 
 for i in $(ls -1 $unprocessed/*@option.ScriptName@.csv); 
 do
     echo "File @option.ScriptName@.csv processing"
  echo $i
  
   cp $i $processed/
   mv $i $unprocessed/@option.ScriptName@.csv
   psql -h pg1.stageku.cete.us -U aart_user -f '/CETE_GENERAL/Technology/helpdesk/scenarios/scripts/@option.ScriptName@.sql' aart-stage &> $i.out.stage
   mv /CETE_GENERAL/Technology/helpdesk/scenarios/*_error.csv $i.error.out.stage
   mv $unprocessed/*.out.stage $processed/
 done;