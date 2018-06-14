--Find kelpa stage info and score info
select st.id,st.modifieddate,ts.stageid,ts.id,kelpascoringstatus,sas.id
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and st.studentid in (1340511,530425,1002832,661403);

begin;

 update  scoringassignmentstudent 
 set kelpascoringstatus=631,
 modifieddate=now(),
 modifieduser=(select id from aartuser where email='ktaduru_sta@ku.edu')
 where id=318664;

  update  scoringassignmentstudent 
 set kelpascoringstatus=631,
 modifieddate=now(),
 modifieduser=(select id from aartuser where email='ktaduru_sta@ku.edu')
 where id in ( 318666,288463,318648);


  update  scoringassignmentstudent 
 set kelpascoringstatus=631,
 modifieddate=now(),
 modifieduser=(select id from aartuser where email='ktaduru_sta@ku.edu')
 where id in
 (342438,
 342467,
 342469,
 388744,
 549266,
 549286,
 549295,
 549403,
 549423,
 549432);
commit;

-- students completed all items but score status in in-prgress

select distinct st.studentid into temp tmp_std 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join enrollment e on e.studentid=st.studentid and e.id=st.enrollmentid and e.activeflag is true
 inner join student s on e.studentid=s.id and s.activeflag is true
 inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and kelpascoringstatus=629
and st.activeflag is true and ts.activeflag is true
and st.status=86;


drop table tmp_report;
select distinct on (sas.studentstestsid) 
    s.id as studentid, 
    orgtd.statename as state,
           orgtd.districtname as district, 
           orgtd.schoolname as school,
           orgtd.schooldisplayidentifier as schoolidentifier,
           gc.name as grade,
           s.legallastname as studentlastname, 
    s.legalfirstname as studentfirstname, 
                  s.legalmiddlename as studentmiddlename, 
                  s.statestudentidentifier as statestudentidentifier,
                  au.uniquecommonidentifier as educatoridentifier, 
                  au.surname as educatorlastname, 
                  au.firstname as educatorfirstname,  
                  ca.name as subject,   
                  tc.name as testcollectionname,
                  stage.name as stagename,
                  sa.ccqtestname as scoringassignmentname, 
                  r.coursesectionname as rostername, 
                  case when cat.categoryname is null then 'Not Scored' ELSE cat.categoryname end as scoringstatus,
                  (select count(distinct smd.taskvariantid) from scoringtestmetadata smd where smd.testid = sas.testid) as qtytoscore,
    (select count(distinct sts.taskvariantid) from studentstestscore sts where sts.studenttestid = sas.studentstestsid and activeflag is true) as scored  
    into temp tmp_report         
     from testsession testsession
     inner join scoringassignment sa on sa.testsessionid = testsession.id and sa.actIveflag is true
     inner join scoringAssignmentstudent sas on sas.scoringassignmentid = sa.id and sas.activeflag is true
     inner join organizationtreedetail orgtd on orgtd.schoolid = testsession.attendanceschoolid
     inner join operationaltestwindow otw ON otw.id = testsession.operationaltestwindowid 
     inner join student s on s.id = sas.studentid and s.activeflag is true
     inner join gradecourse gc on testsession.gradecourseid = gc.id and gc.activeflag is true
     inner join testcollection tc on tc.id = testsession.testcollectionid
     inner join contentarea ca on ca.id = tc.contentareaid
     inner join stage stage on stage.id = testsession.stageid and stage.activeflag is true
     left join roster r on sa.rosterid = r.id  and r.activeflag is true  
     left join aartuser au on au.id = r.teacherid and au.activeflag is true 
     left join category cat on cat.id = sas.kelpascoringstatus and cat.activeflag is true 
     where testsession.schoolyear =  2018 
	and  otw.assessmentprogramid =47 and  s.id in (select studentid from tmp_std) and testsession.activeflag is true ;
--	where qtytoscore-scored=0 and scoringstatus <>'###COMPLETED#### '
\copy (select * from tmp_report) to 'kelpa_scoringassignmentstudent.csv' (FORMAT CSV, HEADER TRUE,FORCE_QUOTE *);

--kelpa : Incative students scoring assignement for nonscored active if students tests active   
select count(distinct st.id)  from studentstests st join testsession ts on st.testsessionid = ts.id 
join scoringassignmentstudent sas on sas.studentstestsid = st.id  
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)  and st.activeflag is false and sas.activeflag is true;

 select  st.status,st.id,st.studentid,manualupdatereason,kelpascoringstatus,st.activeflag,sas.activeflag  from studentstests st join testsession ts on st.testsessionid = ts.id
join scoringassignmentstudent sas on sas.studentstestsid = st.id
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)  and st.activeflag is false and sas.activeflag is true
and (manualupdatereason is not null or kelpascoringstatus is null);

drop table if exists tmp_scoringassignmentstudent;
select distinct st.studentid,schoolname,districtname,statename,st.id studentstestsid, st.activeflag st_activeflag,ts.activeflag ts_activeflag,sas.id sas_id, sas.activeflag sas_activeflag
,operationaltestwindowid,stageid 
 into temp tmp_scoringassignmentstudent
 from studentstests st 
join testsession ts on st.testsessionid = ts.id 
inner join enrollment e on e.id=st.enrollmentid  
inner join organizationtreedetail o on o.schoolid=e.attendanceschoolid  
join scoringassignmentstudent sas on sas.studentstestsid = st.id  
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)  and st.activeflag is false and sas.activeflag is true
-- and (manualupdatereason is not null or kelpascoringstatus is null)
;

\copy (select * from tmp_scoringassignmentstudent) to 'tmp_scoringassignmentstudent_kelpa_03302018.csv' (FORMAT CSV, HEADER TRUE,FORCE_QUOTE *);

begin;
update scoringassignmentstudent 
set activeflag = false,
 modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu')
where activeflag is true
and id in(select distinct sas.id  from studentstests st join testsession ts on st.testsessionid = ts.id
join scoringassignmentstudent sas on sas.studentstestsid = st.id
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)  and st.activeflag is false and sas.activeflag is true
and (manualupdatereason is not null or kelpascoringstatus is null)
);


drop table if exists tmp_scoringassignment;
with all_inactive_sa as (
select sa.id, case when st.activeflag is false and sas.activeflag is true then false else sas.activeflag end activeflag 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9) ) 
select distinct sa.id into temp tmp_scoringassignment from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)
 and sa.id not in (select id from all_inactive_sa where activeflag is true) and sa.activeflag is true;

update scoringassignment
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false,
ccqtestname = ccqtestname || '-' || (SELECT (EXTRACT (MILLISECONDS from now()::time))*1000)
where id in(select id from tmp_scoringassignment) and activeflag is true;


--phase2
update scoringassignmentstudent 
set activeflag = false,
 modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu')
where activeflag is true
and id in(select distinct sas.id  from studentstests st join testsession ts on st.testsessionid = ts.id
join scoringassignmentstudent sas on sas.studentstestsid = st.id
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)  and st.activeflag is false and sas.activeflag is true
-- and (manualupdatereason is not null or kelpascoringstatus is null)
);


drop table if exists tmp_scoringassignment;
with all_inactive_sa as (
select sa.id, case when st.activeflag is false and sas.activeflag is true then false else sas.activeflag end activeflag 
 from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9) ) 
select distinct sa.id into temp tmp_scoringassignment from studentstests st join testsession ts on st.testsessionid = ts.id 
 inner join scoringassignmentstudent sas on sas.studentstestsid = st.id  
 inner join scoringassignment sa on sa.id=sas.scoringassignmentid
where ts.operationaltestwindowid = 10252 and ts.stageid in (8,9)
 and sa.id not in (select id from all_inactive_sa where activeflag is true) and sa.activeflag is true;

update scoringassignment
set modifieddate = now(),
modifieduser = (select id from aartuser where email='ktaduru_sta@ku.edu'),
activeflag = false,
ccqtestname = ccqtestname || '-' || (SELECT (EXTRACT (MILLISECONDS from now()::time))*1000)
where id in(select id from tmp_scoringassignment) and activeflag is true;


 commit;