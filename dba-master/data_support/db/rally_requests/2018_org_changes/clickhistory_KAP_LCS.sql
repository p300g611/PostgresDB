--Step1: Find the missing students responses for LCS students
SELECT distinct schoolname,districtname,statename,st.studentid||'-'||sts.id||'-click.json' as clickhistory, st.id as "studentsTestId",st.studentid,
sr.taskvariantid, sr.createddate::date
FROM studentstests st
join enrollment e on e.id=st.enrollmentid
join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN studentsresponses sr ON sr.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN studentstestsections sts on st.id = sts.studentstestid
JOIN testsection tsec ON tsec.testid = t.id and sts.testsectionid = tsec.id
join testsectionstaskvariants tstv on tsec.id = tstv.testsectionid and sr.taskvariantid = tstv.taskvariantid
WHERE otw.id in (10261,10258) 
AND st.status = 86 
and st.activeflag
and foilid is null 
and response is null
order by sr.createddate::date;

--insert script
WITH sr_count AS(
SELECT  distinct schoolname,districtname,statename, st.testid,sts.testsectionid, st.id as studentstestsid,sts.id studentstestsectionsid,st.studentid||'-'||sts.id||'-click.json' as clickhistory
,st.studentid,t.testname
,(select count(*) from testsectionstaskvariants where testsectionid = tsec.id) as tstvcount
,(select count(*) from studentsresponses where studentstestsid = st.id) as srcount
FROM studentstests st
join enrollment e on e.id=st.enrollmentid
join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentstestsections sts on st.id = sts.studentstestid 
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN testsection tsec ON tsec.testid = t.id
WHERE otw.id in (10261,10258) AND st.status = 86
)
SELECT * FROM sr_count WHERE srcount < tstvcount;

--step2: find the all files list and 

rm tde04232018.out
--copy the all clickhistory file name to file  
aws s3 ls s3://kite-clickhistory-prod/ | awk '{print $4}' >tde04232018.out


--copy the lcs students list to lcsfiles.txt inlude the insert script files also
rm lcsfiles.txt 
-- [p300g611@ip-192-168-4-188 ~]$ tail lcsfiles.txt

-- 877198-32777520-click.json
-- 877203-33301514-click.json
-- 877222-33371184-click.json
-- 880455-32387404-click.json
-- 899958-32017012-click.json
-- 94768-31857716-click.json
-- 94768-32300278-click.json
-- 94768-34627981-click.json
-- 988865-32147404-click.json

--create lcsscript.sh file with below code to loop the lcs students

-- [p300g611@ip-192-168-4-188 ~]$ cat lcsscript.sh
#!/bin/bash
for i in $(cat lcsfiles.txt);
do
    filename=$i
    filename=$(cat  tde04232018.out | fgrep "$i")
    echo $filename >>lcsfinal.csv
    #aws s3 cp s3://kite-clickhistory-prod/$filename s3://kite-sqlite-extracts/tmp/clickhistory/$prefixvar/$filename > /dev/null
done


rm lcsfinal.csv
sh lcsscript.sh
--create lcs_all_copy.sh to copy into helpdesk bucket from lcsfinal.csv file 
--Note: lcsfinal.csv  need to format for to saparte the lines 
--15PMzQR-899958-32017012-click.json 5SGRc7A-899958-32017012-click.json 8AoT1lp-899958-32017012-click.json 


--create copy script to copy all lcs file to help desk folder 

-- [p300g611@ip-192-168-4-188 ~]$ tail lcs_all_copy.sh
-- aws s3 cp s3://kite-clickhistory-prod/9TjNARX-877222-33371184-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/8OLHQ41-880455-32387404-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/15PMzQR-899958-32017012-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/5SGRc7A-899958-32017012-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/8AoT1lp-899958-32017012-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/1AdxDcH-94768-31857716-click.json   s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/8qvni2i-94768-32300278-click.json   s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/1EERyTX-94768-34627981-click.json   s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/7sUZIs0-988865-32147404-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/
-- aws s3 cp s3://kite-clickhistory-prod/38aW3RB-988865-34418921-click.json  s3://kite-sqlite-extracts/tmp/test/helpdesk/

--Step3: run the athena script.

with tmp_response as (
SELECT studentid, studentstestid,studentstestsectionsid, task.id taskid,task.responses,filename
from tdeclickhistory_helpdesk 
cross join unnest (tdeclickhistory_helpdesk.tasks) as t1(task)
--where task.responses is not null
-- where studentid=901868 and studentstestid=21098652
)
select studentid,studentstestid, studentstestsectionsid,taskid,respond.responseoption,respond.isCorrectResponse,respond.ts,respond.score,filename
from tmp_response 
cross join unnest(tmp_response.responses) as t2(respond)
where respond.responseoption is not null-- and studentid=481569 and studentstestsectionsid=24701622 and taskid=378250
order by studentid, taskid;

--download the csv file copy(04092018_all.csv) to dbutil to run scripts 

 
-- SELECT distinct st.studentid||'-'||sts.id||'-click.json' as clickhistory, st.id as "studentsTestId",st.studentid,t.testname,(select count(*) from testsectionstaskvariants where testsectionid = tsec.id) as tstvcount, (select count(*) from studentsresponses where studentstestsid = st.id) as srcount, sr.taskvariantid,
-- sr.foilid as foilid,sr.response as response
select distinct sr.studentstestsectionsid,sr.taskvariantid,foilid,score,sr.modifieddate,sr.response,lcs.lcsid,sr.modifieduser 
into temp tmp_ep_responses
FROM studentstests st
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN studentsresponses sr ON sr.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN studentstestsections sts on st.id = sts.studentstestid
JOIN testsection tsec ON tsec.testid = t.id and sts.testsectionid = tsec.id
join testsectionstaskvariants tstv on tsec.id = tstv.testsectionid and sr.taskvariantid = tstv.taskvariantid
WHERE otw.id in (10261,10258) and ts.schoolyear=2018
AND st.status = 86 
and st.activeflag
and foilid is null 
and response is null;

--backup
\copy (select * from tmp_ep_responses) to 'kap_lcs_missing_response_beforeupdate_04242018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

create temp table tmp_aws_reponses 
(studentid bigint, studentstestid bigint, studentstestsectionsid bigint,taskid bigint,responseoption text,iscorrectresponse text,ts text,score text,filename text);

\COPY tmp_aws_reponses FROM 'aws_response_2.csv' DELIMITER ',' CSV HEADER ;

with  dups as (select *,row_number() over( partition by studentstestsectionsid,taskid order by ts desc) row_num from tmp_aws_reponses ) 
select * into temp tmp_aws_reponses_max from dups where row_num=1;

--validation files 
select 
 aws.studentid                                    aws_studentid              
,aws.studentstestid         			  aws_studentstestid         
,aws.studentstestsectionsid 			  aws_studentstestsectionsid 
,aws.taskid                 			  aws_taskid                 
,aws.responseoption         			  aws_responseoption         
,aws.iscorrectresponse      			  aws_iscorrectresponse      
,aws.ts                     			  aws_ts                     
,aws.score                  			  aws_score                  
,aws.filename               			  aws_filename               
,aws.row_num                			  aws_row_num                
,ep.studentstestsectionsid 			  ep_studentstestsectionsid 
,ep.taskvariantid           		          ep_taskvariantid          
,ep.foilid                 			  ep_foilid                 
,ep.score                  			  ep_score                  
,ep.modifieddate           			  ep_modifieddate           
,ep.response               			  ep_response   
,ep.lcsid                                         ep_lcsid
 into temp tmp_result 
 from tmp_aws_reponses_max aws
 join tmp_ep_responses ep 
on ep.studentstestsectionsid=aws.studentstestsectionsid and ep.taskvariantid=aws.taskid; 


-- select  ep.* from tmp_ep_responses ep
-- left outer join tmp_aws_reponses_max aws
-- on ep.studentstestsectionsid=aws.studentstestsectionsid and ep.taskvariantid=aws.taskid
-- where aws.studentstestsectionsid is null;


\copy (select * from tmp_result) to 'tmp_result_missing_response_all_lcs.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select *,row_number() over( partition by studentstestsectionsid,taskid order by ts desc) row_num from tmp_aws_reponses) to 'tmp_result_missing_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--step4:Update process 
--rescoring process 

begin;
INSERT INTO taskvariantrescore (taskvariantid,cbtaskvariantid,reason,studenttestsectionids)
SELECT distinct tv.id taskvariantid,tv.externalid cbtaskvariantid,'LCS reposones from Clickhistory',ARRAY_AGG(aws.studentstestsectionsid) 
 from tmp_aws_reponses_max aws
 join tmp_ep_responses ep on ep.studentstestsectionsid=aws.studentstestsectionsid and ep.taskvariantid=aws.taskid
 inner join taskvariant tv on tv.id=aws.taskid
 INNER JOIN tasktype tt on tt.id = tv.tasktypeid
GROUP BY tv.id,tv.externalid;

commit;


--Update missing responses 

--*****Warning***** find the item type make sure case statement correct 
select tt.code,count(*)	from tmp_aws_reponses_max aws
join tmp_ep_responses ep on ep.studentstestsectionsid=aws.studentstestsectionsid and ep.taskvariantid=aws.taskid
inner join taskvariant tv on tv.id=aws.taskid
INNER JOIN tasktype tt on tt.id = tv.tasktypeid
group by tt.code;


update studentsresponses ep 
set foilid = case when code='MC-K' then aws_responseoption::bigint else ep.foilid end 
,response= case when code='MC-K'   then ep.response else aws_responseoption end 
,modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu')
,modifieddate=now()
from (select distinct 
	aws.studentstestsectionsid 			  aws_studentstestsectionsid 
	,aws.taskid                 			  aws_taskid                 
	,aws.responseoption         			  aws_responseoption         
	,aws.score                  			  aws_score
    ,tt.code	
 from tmp_aws_reponses_max aws
 join tmp_ep_responses ep on ep.studentstestsectionsid=aws.studentstestsectionsid and ep.taskvariantid=aws.taskid
 inner join taskvariant tv on tv.id=aws.taskid
 INNER JOIN tasktype tt on tt.id = tv.tasktypeid) aws
where ep.studentstestsectionsid=aws.aws_studentstestsectionsid and ep.taskvariantid=aws.aws_taskid
and ep.response is null and ep.response is null; 


--step5:Insert process for missing upload 

WITH sr_count AS(
SELECT st.testid,sts.testsectionid, st.id as studentstestsid,sts.id studentstestsectionsid
,st.studentid,t.testname
,(select count(*) from testsectionstaskvariants where testsectionid = tsec.id) as tstvcount
,(select count(*) from studentsresponses where studentstestsid = st.id) as srcount
FROM studentstests st
JOIN studentstestsections sts on st.id = sts.studentstestid 
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN testsection tsec ON tsec.testid = t.id
WHERE otw.id in (10261,10258) AND st.status = 86
)
SELECT * into temp tmp_ep_items FROM sr_count WHERE srcount < tstvcount;


select ep.testid,ep.testsectionid,ep.studentstestsid,sr.studentstestsectionsid,sr.taskvariantid
into temp tmp_ep_items_all
from studentsresponses sr
inner join tmp_ep_items ep on ep.studentstestsectionsid=sr.studentstestsectionsid;

--rescoring process 

begin;
INSERT INTO taskvariantrescore (taskvariantid,cbtaskvariantid,reason,studenttestsectionids)
SELECT distinct tv.id taskvariantid,tv.externalid cbtaskvariantid,'LCS reposones from Clickhistory',ARRAY_AGG(aws.studentstestsectionsid)  
FROM studentstests st
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN studentstestsections sts on st.id = sts.studentstestid
JOIN testsection tsec ON tsec.testid = t.id and sts.testsectionid = tsec.id
join testsectionstaskvariants tstv on tsec.id = tstv.testsectionid --and sr.taskvariantid = tstv.taskvariantid
inner join tmp_aws_reponses_max aws on sts.id=aws.studentstestsectionsid and tstv.taskvariantid=aws.taskid
inner join taskvariant tv on tv.id=aws.taskid
INNER JOIN tasktype tt on tt.id = tv.tasktypeid
inner join tmp_ep_items ep on ep.studentstestsectionsid=aws.studentstestsectionsid
left outer JOIN tmp_ep_items_all sr ON sr.studentstestsectionsid=aws.studentstestsectionsid and sr.taskvariantid=aws.taskid
WHERE otw.id in (10261,10258) 
AND st.status = 86 
and st.activeflag
and sr.studentstestsectionsid is null
group by tv.id,tv.externalid;

--insert students responses 
INSERT INTO public.studentsresponses(studentid, testid, testsectionid, studentstestsid, studentstestsectionsid,
            taskvariantid, foilid, response, createddate, modifieddate, createduser, modifieduser, activeflag)
select distinct 
 aws.studentid                                    aws_studentid    
,ep.testid                                         testid
,ep.testsectionid                                testsectionid
,ep.studentstestsid         			  aws_studentstestid         
,ep.studentstestsectionsid 			  aws_studentstestsectionsid 
,aws.taskid                 			  taskvariantid       
,case when code='MC-K' then aws.responseoption::bigint else null end  foilid
,case when code='MC-K'   then null else aws.responseoption end   response       
,now()         
,now()     
,(select id from aartuser where username ='ats_dba_team@ku.edu')
,(select id from aartuser where username ='ats_dba_team@ku.edu')
,true  
FROM studentstests st
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN studentstestsections sts on st.id = sts.studentstestid
JOIN testsection tsec ON tsec.testid = t.id and sts.testsectionid = tsec.id
join testsectionstaskvariants tstv on tsec.id = tstv.testsectionid --and sr.taskvariantid = tstv.taskvariantid
inner join tmp_aws_reponses_max aws on sts.id=aws.studentstestsectionsid and tstv.taskvariantid=aws.taskid
inner join taskvariant tv on tv.id=aws.taskid
INNER JOIN tasktype tt on tt.id = tv.tasktypeid
inner join tmp_ep_items ep on ep.studentstestsectionsid=aws.studentstestsectionsid
left outer JOIN tmp_ep_items_all sr ON sr.studentstestsectionsid=aws.studentstestsectionsid and sr.taskvariantid=aws.taskid
WHERE otw.id in (10261,10258) 
AND st.status = 86 
and st.activeflag
and sr.studentstestsectionsid is null;

commit;

--Please run re-score process


