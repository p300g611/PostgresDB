--validation for missing score assigments
select count(distinct st.studentid) from studentstests st
join testsession ts on  st.testsessionid=ts.id
left outer join scoringassignmentstudent sas on st.id = sas.studentstestsid 
left outer join scoringassignment sa on sa.id = sas.scoringassignmentid and ts.id = sa.testsessionid
where ts.activeflag is true and st.activeflag is true 
and ts.operationaltestwindowid = 10258 and ts.stageid=3 --and st.studentid=60224
and sa.id is null;

--validation for inactive all inactive scroring assigment student for active assigment
with all_inactive_sa as (
select sa.id, case when st.activeflag is false and sas.activeflag is true then false else sas.activeflag end activeflag 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3) 
select distinct sa.id from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3 
 and sa.id not in (select id from all_inactive_sa where activeflag is true);


select distinct ts.operationaltestwindowid , ts.stageid,st.activeflag,sas.activeflag,count(distinct st.id)
from studentstests st join testsession ts on st.testsessionid = ts.id 
inner join scoringassignmentstudent sas on sas.studentstestsid = st.id 
where sas.scoringassignmentid =35654
group by ts.operationaltestwindowid , ts.stageid,st.activeflag,sas.activeflag;


-- Update script has depencency 
select distinct sas.id into temp tmp_scoringassignmentstudent
from scoringassignmentstudent sas join scoringassignment sa on sa.id = sas.scoringassignmentid 
join testsession ts on ts.id = sa.testsessionid 
join studentstests st on st.id = sas.studentstestsid 
where ts.activeflag is false 
and st.activeflag is false 
and ts.operationaltestwindowid = 10258 
and ts.stageid=3 
and sa.activeflag is true 
and sas.activeflag is true;

select distinct sa.id into temp tmp_scoringassignment
from scoringassignmentstudent sas 
join scoringassignment sa on sa.id = sas.scoringassignmentid 
join testsession ts on ts.id = sa.testsessionid 
join studentstests st on st.id = sas.studentstestsid 
where ts.activeflag is false 
and st.activeflag is false 
and ts.operationaltestwindowid = 10258 
and ts.stageid=3 
and sa.activeflag is true 
and sas.activeflag is true;

drop table if exists tmp_scoringassignmentstudent;
select distinct st.studentid,schoolname,districtname,statename,st.id studentstestsid, st.activeflag st_activeflag,ts.activeflag ts_activeflag,sas.id sas_id, sas.activeflag sas_activeflag
,operationaltestwindowid,stageid 
 into temp tmp_scoringassignmentstudent
 from studentstests st 
join testsession ts on st.testsessionid = ts.id 
inner join enrollment e on e.id=st.enrollmentid  
inner join organizationtreedetail o on o.schoolid=e.attendanceschoolid  
join scoringassignmentstudent sas on sas.studentstestsid = st.id  
where ts.operationaltestwindowid = 10258 and ts.stageid = 3  and st.activeflag is false and sas.activeflag is true;

\copy (select * from tmp_scoringassignmentstudent) to 'tmp_scoringassignmentstudent.csv' (FORMAT CSV, HEADER TRUE,FORCE_QUOTE *);

begin;

/*
update scoringassignmentstudent
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false
where id in(select id from tmp_scoringassignmentstudent) and activeflag is true;

update scoringassignment
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false,
ccqtestname = ccqtestname || '-' || (SELECT (EXTRACT (MILLISECONDS from now()::time))*1000)
where id in(select id from tmp_scoringassignment) and activeflag is true;
*/


update scoringassignmentstudent 
set activeflag = false,
 modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu')
where activeflag is true
and studentstestsid in(select distinct st.id  from studentstests st join testsession ts on st.testsessionid = ts.id 
join scoringassignmentstudent sas on sas.studentstestsid = st.id  
where ts.operationaltestwindowid = 10258 and ts.stageid = 3  and st.activeflag is false and sas.activeflag is true);

drop table if exists tmp_scoringassignment;
with all_inactive_sa as (
select sa.id, case when st.activeflag is false and sas.activeflag is true then false else sas.activeflag end activeflag 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3) 
select distinct sa.id into temp tmp_scoringassignment from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3 
 and sa.id not in (select id from all_inactive_sa where activeflag is true) and sa.activeflag is true;

update scoringassignment
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false,
ccqtestname = ccqtestname || '-' || (SELECT (EXTRACT (MILLISECONDS from now()::time))*1000)
where id in(select id from tmp_scoringassignment) and activeflag is true;

commit;


--validation: incorrect roster on students tests scoring assignments

select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.createddate,er.modifieddate,r.coursesectionname, statesubjectareaid,r.attendanceschoolid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=186639 and statesubjectareaid=443
order by statesubjectareaid,er.activeflag;

select st.id,st.studentid,st.enrollmentid,st.status,ts.name,st.testsessionid,st.scoringassignmentid,
       ts.activeflag as ts_flg, st.activeflag as st_flg,st.createddate,sa.rosterid
from studentstests st 
inner join testsession ts on st.testsessionid = ts.id  
left outer join scoringassignment sa on sa.id=st.scoringassignmentid
where ts.schoolyear=2018 
and ts.operationaltestwindowid = 10258 and ts.stageid = 3 and ts.subjectareaid=20
and studentid in(select id from student where stateid=51 and id=186639);


drop table if exists tmp_scoringassignmentstudent;
select distinct st.studentid,st.enrollmentid,st.id studentstestsid,st.testsessionid,st.scoringassignmentid,sa.rosterid old_rosterid,r.id new_rosterid,st.status,sas.id scoringassignmentstudentid
into temp tmp_scoringassignmentstudent
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join enrollment e on e.id=st.enrollmentid 
 inner join enrollmentsrosters er on e.id=er.enrollmentid
 inner join roster r on r.id=er.rosterid and r.statesubjectareaid=443
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid and st.scoringassignmentid=sa.id
where ts.operationaltestwindowid = 10258 and ts.stageid = 3 and ts.subjectareaid=20
--  and st.status <>86
 and coalesce(kelpascoringstatus,0)<>631 
 and st.activeflag is true and ts.activeflag is true 
 and e.activeflag is true and e.currentschoolyear=2018
 and er.activeflag is true and r.activeflag is true
 and st.scoringassignmentid is not null 
 and (er.rosterid<>sa.rosterid);
--  AND st.studentid in (select id from student where stateid=51 and statestudentidentifier='8143693724');

\copy (select * from tmp_scoringassignmentstudent) to 'tmp_scoringassignmentstudent.csv' (FORMAT CSV, HEADER TRUE,FORCE_QUOTE *);



begin;

update scoringassignmentstudent 
set activeflag = false,
 modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu')
where activeflag is true
and id in(select distinct scoringassignmentstudentid from tmp_scoringassignmentstudent);

update studentstests 
set scoringassignmentid = null,
 modifieddate = now(),
 modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
 manualupdatereason=manualupdatereason||'DE17013 SS clear scoring assignments'
where activeflag is true
and id in(select distinct studentstestsid from tmp_scoringassignmentstudent); 

drop table if exists tmp_scoringassignment;
with all_inactive_sa as (
select sa.id, case when st.activeflag is false and sas.activeflag is true then false else sas.activeflag end activeflag 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3) 
select distinct sa.id into temp tmp_scoringassignment from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10258 and ts.stageid = 3 
 and sa.id not in (select id from all_inactive_sa where activeflag is true) and sa.activeflag is true;

update scoringassignment
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false,
ccqtestname = ccqtestname || '-' || (SELECT (EXTRACT (MILLISECONDS from now()::time))*1000)
where id in(select id from tmp_scoringassignment) and activeflag is true;

commit;




 