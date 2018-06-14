#!/bin/bash


#CB counts check 
psql -h cbdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal_reader -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_prod.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_prod.csv
psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal_reader -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_stage.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_stage.csv

#psql 
psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal_reader -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts_compare.sql"

mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_diff.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_diff.csv



#EP counts check 
psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartprod -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_prod.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_prod.csv
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartstage -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_stage.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_stage.csv

#psql 
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartstage -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts_compare.sql"

mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_diff.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_diff.csv


#EP AUDIT counts check 
psql -h aartauditdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartauditprod -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_prod.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_prod.csv
psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartauditstage -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_stage.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_stage.csv

#psql 
psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -d aartauditstage -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts_compare.sql"

mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_diff.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_diff.csv


#DW counts check 
psql -h aartdwdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw_reader -d aartdw -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_prod.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_prod.csv
psql -h aartdwdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw_reader -d aartdw -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts.sql"
cp /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_stage.csv
mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_stage.csv

#psql 
psql -h aartdwdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw_reader -d aartdw -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/table_counts_compare.sql"

mv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_diff.csv /srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_cb_diff.csv


#In Stage aart
select min(id) from aartuser -->> minxuserid
select max(id) from aartuser -->> maaxuserid
select surname from aartuser where id=minuserid -->> minusername
select surname from aartuser where id=maxuserid -->> maxusername


select min(id) from student -->> minstudentd
select max(id) from student -->> maxstudentd
select legallastname from student where id=minstudentid -->> minstudentlast
select legallastname from student where id=maxstudentid -->> maxstudentlast


select min(id) from studentstests -->> minstudentstestid
select max(id) from studentstests -->> maxstudentstestid
select testid from studentstests where id=minstudentstestid -->> mintestid
select testid from studentstests where id=maxstudentstestid -->> maxtestid

#Compare to same in Production aart

#In Stage cb
select min(nodeid) from cb.lmpublishednodeattribute -->> minnodeid
select max(nodeid) from cb.lmpublishednodeattribute -->> maxnodeid
select username from cb.lmpublishednodeattribute where nodeid=minnodeid -->> minnodeid
select username from cb.lmpublishednodeattribute where nodeid=maxnodeid -->> maxnodeid

select min(accessibilityfileid) from cb.accessibilityfile -->> minaccessid
select max(accessibilityfileid) from cb.accessibilityfile -->> maxaccessid
select companyid from cb.accessibilityfile where accessibilityfileid=minaccessid -->> mincompanyid
select companyid from cb.accessibilityfile where accessibilityfileid=maxaccessid -->> maxcompanyid

select min(taskid) from cb.taskshare -->> mintaskid
select max(taskid) from cb.taskshare -->> maxtaskid
select organizationid from cb.taskshare where taskid=mintaskid -->> minorgid
select organizationid from cb.taskshare where taskid=maxtaskid -->> maxorgid


## compare data

#In Stage aartaudit

select min(id) from batchupload -->> minbatchid
select max(id) from batchupload -->> maxbatchid
select filename from batchupload where id=minbatchid -->> minfilename
select filename from batchupload where id=maxbatchid -->> maxfilename

select min(id) from domainaudithistory -->> minhistoryid
select max(id) from domainaudithistory -->> maxhistoryid
select source from domainaudithistory where id=minhistoryid -->> minsource
select source from domainaudithistory where id=maxhistoryid -->> maxsource

## compare data


#AART PROD
\copy (select id,createduser,createddate from student  order by id desc limit 100;) to 'tmp_table.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

#AART STAGE 
drop table if exists tmp_table;
create temp table tmp_table (id bigint, createduser text,createddate text);

\COPY tmp_table FROM 'tmp_table.csv' DELIMITER ',' CSV HEADER ;

#Compare 
select count(*) from student src
inner join tmp_table tgt on src.id=tgt.id
where coalesce(src.createduser::text,'')<>coalesce(tgt.createduser::text,'') or 
      coalesce(src.createddate::text,'')<>coalesce(tgt.createddate::text,'');
