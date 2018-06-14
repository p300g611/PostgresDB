/*
--orginal script from 2017
https://code.cete.us/svn/dlm/tde/trunk/db/other/cpass-scoring-issues-2018-schoolyear/taskvariantrescore-insert.sql

--Please execute the below query in PROD and give me the output in CSV file. This is to identify the duplicate values in student response data for TE items.

select * from (select sr.studentstestsid,sr.studentstestsectionsid,sr.taskvariantid,tv.tasksubtypeid,sr.createddate,sr.modifieddate,sr.score,tv.maxscore,
(select count(*) from (select unnest(string_to_array((substr(response,3,length(response)-4)),'},{'))
from studentsresponses where studentstestsectionsid=sr.studentstestsectionsid and taskvariantid=sr.taskvariantid) as s1) as initial_length,
(select count(*) from (select distinct unnest(string_to_array((substr(response,3,length(response)-4)),'},{'))
from studentsresponses where studentstestsectionsid=sr.studentstestsectionsid and taskvariantid=sr.taskvariantid) as s1) as unique_length
from studentstests st
INNER JOIN studentstestsections sts on sts.studentstestid = st.id
INNER JOIN testsectionstaskvariants tstv on tstv.testsectionid = sts.testsectionid
INNER JOIN taskvariant tv on tv.id = tstv.taskvariantid
INNER JOIN studentsresponses sr on sr.studentstestsectionsid = sts.id and sr.taskvariantid = tv.id
INNER JOIN tasktype tt on tt.id = tv.tasktypeid
INNER JOIN student s on (st.studentid = s.id)
INNER JOIN enrollment e on (s.id = e.studentid)
where tt.code='ITP' and e.currentschoolyear=2017 and e.activeflag is true and st.activeflag is true) as temp
where initial_length<>unique_length;

--Note: Please execute after testing window closed. It took around 2 mins in Stage, but it might take more time in PROD.

*/

--login with aart
drop table if exists tmp_sr_res;
with itp_items as (
select tv.id,tv.externalid,maxscore,tasksubtypeid from taskvariant tv 
INNER JOIN tasktype tt on tt.id = tv.tasktypeid
where tt.code='ITP')
select distinct sr.studentstestsid,sr.studentstestsectionsid,sr.taskvariantid,tv.tasksubtypeid,sr.createddate,sr.modifieddate,sr.score,tv.maxscore,tv.externalid
 into temp tmp_sr_res
from studentstests st
inner join testsession ts on ts.id=st.testsessionid
INNER JOIN studentstestsections sts on sts.studentstestid = st.id
INNER JOIN testsectionstaskvariants tstv on tstv.testsectionid = sts.testsectionid
inner join itp_items tv on tv.id=tstv.taskvariantid
INNER JOIN studentsresponses sr on sr.studentstestsectionsid = sts.id and sr.taskvariantid = tv.id
where  ts.schoolyear=2018 and st.activeflag is true;

drop table if exists tmp_final_new;
select * into temp tmp_final_new  from (
select sr.studentstestsid,sr.studentstestsectionsid,sr.taskvariantid,sr.externalid as cbtaskvariantid,
sr.tasksubtypeid,sr.createddate,sr.modifieddate,sr.score,sr.maxscore,
(select count(*) from (select unnest(string_to_array((substr(response,3,length(response)-4)),'},{'))
from studentsresponses where studentstestsectionsid=sr.studentstestsectionsid and taskvariantid=sr.taskvariantid and length(response)>4) as s1) as initial_length,
(select count(*) from (select distinct unnest(string_to_array((substr(response,3,length(response)-4)),'},{'))
from studentsresponses where studentstestsectionsid=sr.studentstestsectionsid and taskvariantid=sr.taskvariantid and length(response)>4) as s1) as unique_length
from tmp_sr_res sr
) as tem
where initial_length<>unique_length;

drop table sr_backup;
select distinct sr.studentid,sr.studentstestsid,sr.studentstestsectionsid,sr.taskvariantid,sr.response 
  into temp sr_backup
 from tmp_final_new tmp inner join studentsresponses sr
 on tmp.studentstestsid=sr.studentstestsid and sr.studentstestsectionsid=tmp.studentstestsectionsid and sr.taskvariantid=tmp.taskvariantid;

\copy (select * from sr_backup) to 'kap_score_duplicate_item20180418.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)

begin;
INSERT INTO taskvariantrescore (taskvariantid,cbtaskvariantid,reason,studenttestsectionids)
SELECT taskvariantid,cbtaskvariantid,'Removed duplicate values in student response data',ARRAY_AGG(studentstestsectionsid) from tmp_final_new
GROUP BY taskvariantid,cbtaskvariantid;

commit;

BEGIN;

UPDATE studentsresponses sr
SET response=('[{'||array_to_string(ARRAY(select distinct unnest(string_to_array((substr(response,3,length(response)-4)),'},{'))  from studentsresponses where studentstestsectionsid=tmp.studentstestsectionsid and taskvariantid=tmp.taskvariantid),'},{')||'}]')
,modifieddate=now() 
FROM tmp_final_new tmp
WHERE sr.studentstestsectionsid=tmp.studentstestsectionsid and sr.taskvariantid=tmp.taskvariantid;

COMMIT;

-- clear json data
begin;

delete from testjson where testid in 
( select distinct t.id from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
where tv.externalid=8274 and t.createdate>'2017-08-01');

commit;

/*
 * To execute rescoring service run the following command 
 *  curl -v I -X GET  "http://integration.prodku.cete.us/epservices/rescore"
 */


--Item 
insert into taskvariantrescore (taskvariantid,cbtaskvariantid,scoringdata,newscoringdata,reason) select id,externalid,scoringdata,'[{"correctResponse":{"value":"56.52","score":"1.0000"},"acceptableResponses":[{"value":"56.52","score":"1.0000","index":"0"},{"value":"56.5","score":"1.0000","index":"0"}]}]', 'Scoring data is changed' from taskvariant where externalid=8274;
update taskvariant set scoringdata='[{"correctResponse":{"value":"56.52","score":"1.0000"},"acceptableResponses":[{"value":"56.52","score":"1.0000","index":"0"},{"value":"56.5","score":"1.0000","index":"0"}]}]',modifieddate=now() where  externalid=8274;


--validation 
select studentid,studentstestsid,createddate,taskvariantid
from studentsresponses  where taskvariantid  in ( select id from taskvariant  where externalid  =8274)
and createddate>'2017-08-01' 
and score=0.500;

select studentid,studentstestsid,createddate,taskvariantid,score,response,*
from studentsresponses  where taskvariantid  in ( select id from taskvariant  where externalid  =35501)
and createddate>'2017-08-01' and score>2;


select studentid,studentstestsid,createddate,taskvariantid,score,response,*
from studentsresponses  where taskvariantid  in ( select id from taskvariant  where externalid  =36072)
and createddate>'2017-08-01' and score>1;