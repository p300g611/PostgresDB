--Analysis :1 
--Please run the select script first to make sure status available for iti,ts,sts,st tables
create temp table tmp_orgyear (orgid bigint ,orgyear int,statename text);
insert into tmp_orgyear
select schoolid orgid,2017 orgyear,statename from organizationtreedetail 
where coalesce(organization_school_year(stateid),extract(year from now()))=2017 
and stateid not in (select id from organization where  organizationtypeid=2 
and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland'));


--exclude students





--all
-- 78911,144036,445568,445568,506733,508213,508213,655773,725526,725526,729159,729186,828112,854813,855082,855689,856188,856879,858298,
-- 863803,865338,881615,890128,890993,890993,917471,926988,927098,1162944,1205792,1205881,1206005,1207690,1210088,1315097,1324506,1324507
-- ,1325039,1325508,1328635,1332748,1333095,1335399


drop table if exists tmp_exit_exclude_ela;
select ort.statename,ort.districtname,ort.schoolname,s.id studentid,s.statestudentidentifier,en.id enrollid,r.id rosterid
-- ,statecoursecode 
-- ,en.activeflag enrollactive
-- ,er.id enrollrosterid
-- ,er.activeflag enrollrosteractive
into temp tmp_exit_exclude_ela
from student s 
inner join enrollment en on s.id=en.studentid and s.activeflag is true
inner join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid and ort.stateid=s.stateid
inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join enrollmentsrosters er on en.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where sap.assessmentprogramid=3 and statesubjectareaid=3 and 
s.id in (78911,445568,655773,729159,729186,828112,854813,855689,856188,856879,863803,865338,
873153,881615,890128,917471,1162944,1205881,1206005,1210088,1315097,1324506,1324507,
1325508,1325674,1325675,1328635,1332748,1333095,1335399,890993);



drop table if exists tmp_student_exit_inactive_roster_ela;
select tmp.*,tc.contentareaid,t.testname testname,c.categorycode,ts.name,ts.rosterid sessionrosterid,st.enrollmentid testenrollid,st.id studentstestsid,ts.id testsessionid
into temp tmp_student_exit_inactive_roster_ela
 from tmp_exit_exclude_ela tmp
inner join studentstests st on tmp.studentid=st.studentid
inner join category c on c.id=st.status 
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
inner join testcollection tc on tc.id=st.testcollectionid and tc.contentareaid=3
-- where ts.rosterid<>enrollrosterid
order by tmp.statename,tmp.studentid,tc.contentareaid;


\copy (select * from tmp_student_exit_inactive_roster_ela) to 'tmp_student_exit_inactive_roster_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



--exclude condition
-- how are inactive from craig list completed tests

drop table if exists tmp_exit_exclude_m;
select ort.statename,ort.districtname,ort.schoolname,s.id studentid,s.statestudentidentifier,en.id enrollid,r.id rosterid
-- ,statecoursecode 
-- ,en.activeflag enrollactive
-- ,er.id enrollrosterid
-- ,er.activeflag enrollrosteractive
into temp tmp_exit_exclude_m
from student s 
inner join enrollment en on s.id=en.studentid and s.activeflag is true
inner join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid and ort.stateid=s.stateid
inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join enrollmentsrosters er on en.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where sap.assessmentprogramid=3 and statesubjectareaid=440 and 
s.id in (144036,508213,655773,729159,729186,854813,855082,855689,856879,863803,865338,
867699,873153,881615,890128,890993,917471,927098,1205881,1206005,1324506,1324507,1328635,1332748,1333095,1335399,508213,445568);


-- (144036,508213,655773,725526,729159,729186,854813,855082,855689,856879,863803,865338,
-- 867699,873153,881615,890128,890993,917471,927098,1205881,1206005,1324506,1324507,1328635,1332748,1333095,1335399,508213,445568);

drop table if exists tmp_student_exit_inactive_roster_m;
select tmp.*,tc.contentareaid,t.testname testname,c.categorycode,ts.name,ts.rosterid sessionrosterid,st.enrollmentid testenrollid,st.id studentstestsid,ts.id testsessionid
into temp tmp_student_exit_inactive_roster_m
 from tmp_exit_exclude_m tmp
inner join studentstests st on tmp.studentid=st.studentid
inner join category c on c.id=st.status 
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
inner join testcollection tc on tc.id=st.testcollectionid and tc.contentareaid=440
-- where ts.rosterid<>enrollrosterid
order by tmp.statename,tmp.studentid,tc.contentareaid;


\copy (select * from tmp_student_exit_inactive_roster_m) to 'tmp_student_exit_inactive_roster_m.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);





--================================================================================================================
--1.1--Actively enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course

--ELA validation
select tmp.statename,studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=3
-- and r.createduser<>13
group by  tmp.statename,studentid,statesubjectareaid
having count(distinct r.id)>1;

--FIND the student list:
drop table if exists tmp_active_roster_ela;
with oth_roster as (
select statename,studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=3
-- and r.createduser<>13
group by  statename,studentid,statesubjectareaid
having count(distinct r.id)>1)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.id enrollid,r.coursesectionname,er.id enrollrosterid
  into temp tmp_active_roster_ela 
from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid 
where r.currentschoolyear=2017 and e.activeflag is true and er.activeflag is true 
and er.activeflag is true and r.statesubjectareaid=3 --and r.createduser<>13
;

drop table if exists tmp_active_roster_ela_fix;
select *  into temp tmp_active_roster_ela_fix
from tmp_active_roster_ela tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=3
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid --and st.ts_rosterid=tmp.rosterid
order by tmp.studentid;

\copy (select * from tmp_active_roster_ela_fix tmp ) to 'tmp_active_roster_ela_fix.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;

select distinct enrollrosterid
 from tmp_active_roster_ela_fix tmp
 where ts_rosterid<>rosterid and st_status is not null;
 
--have students testsessions
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select distinct enrollrosterid
 from tmp_active_roster_ela_fix tmp
 where ts_rosterid<>rosterid);


select  studentid,enrollrosterid,statecoursecode,enrollid,st_status
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end desc,enrollrosterid desc) row_num
  ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end ,enrollrosterid) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end ,enrollrosterid ) row_num
 from tmp_active_roster_ela_fix tmp
 where st_status is null;

 
--remove from other roster
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select enrollrosterid from 
(select enrollrosterid,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
 from tmp_active_roster_ela_fix tmp
 where st_status is null) a where row_num<>1);
 
commit;



--================================================================================================================
--1.2--Actively enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course

--Math validation
select statename,studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=440
-- and r.createduser<>13
group by  statename,studentid,statesubjectareaid
having count(distinct r.id)>1;

--FIND the student list:
drop table if exists tmp_active_roster_m;
with oth_roster as (
select studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=440
-- and r.createduser<>13
group by  studentid,statesubjectareaid
having count(distinct r.id)>1)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.id enrollid,r.coursesectionname,er.id enrollrosterid
  into temp tmp_active_roster_m 
from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid 
where r.currentschoolyear=2017 and e.activeflag is true and er.activeflag is true 
and er.activeflag is true and r.statesubjectareaid=440 --and r.createduser<>13
;

drop table if exists tmp_active_roster_m_fix;
select *  into temp tmp_active_roster_m_fix
from tmp_active_roster_m tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=440
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid --and st.ts_rosterid=tmp.rosterid
order by tmp.studentid;

\copy (select * from tmp_active_roster_m_fix ) to 'tmp_active_roster_math_fix.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;

select distinct enrollrosterid
 from tmp_active_roster_m_fix tmp
 where ts_rosterid<>rosterid and st_status is not null;
 
--have students testsessions
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select distinct enrollrosterid
 from tmp_active_roster_m_fix tmp
 where ts_rosterid<>rosterid);


select  studentid,enrollrosterid,statecoursecode,enrollid,st_status
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end desc,enrollrosterid desc) row_num
  ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end ,enrollrosterid) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end ,enrollrosterid ) row_num
 from tmp_active_roster_m_fix tmp
 where st_status is null;

 
--remove from other roster
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select enrollrosterid from 
( select enrollrosterid,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
 from tmp_active_roster_m_fix tmp
 where st_status is null) a where row_num<>1);
 
commit; 

--================================================================================================================
--1.3--Actively enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course

--SCI validation
select statename,studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=441
-- and r.createduser<>13
group by  statename,studentid,statesubjectareaid
having count(distinct r.id)>1;

--FIND the student list:
drop table if exists tmp_active_roster_sci;
with oth_roster as (
select studentid,statesubjectareaid,count(distinct r.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true and statesubjectareaid=441
-- and r.createduser<>13
group by  statename,studentid,statesubjectareaid
having count(distinct r.id)>1)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.id enrollid,r.coursesectionname,er.id enrollrosterid
  into temp tmp_active_roster_sci 
from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid 
where r.currentschoolyear=2017 and e.activeflag is true and er.activeflag is true 
and er.activeflag is true and r.statesubjectareaid=441 --and r.createduser<>13
;

drop table if exists tmp_active_roster_sci_fix;
select *  into temp tmp_active_roster_sci_fix
from tmp_active_roster_sci tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=441
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid --and st.ts_rosterid=tmp.rosterid
order by tmp.studentid;

\copy (select * from tmp_active_roster_sci_fix ) to 'tmp_active_roster_sci_fix.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;

select distinct enrollrosterid
 from tmp_active_roster_sci_fix tmp
 where ts_rosterid<>rosterid and st_status is not null;
 
--have students testsessions
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select distinct enrollrosterid
 from tmp_active_roster_sci_fix tmp
 where ts_rosterid<>rosterid);


select  studentid,enrollrosterid,statecoursecode,enrollid,st_status
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end desc,enrollrosterid desc) row_num
  ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 10 else 0 end ,enrollrosterid) row_num
--   ,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end ,enrollrosterid ) row_num
 from tmp_active_roster_sci_fix tmp
 where st_status is null;

 
--remove from other roster
 update enrollmentsrosters 
 set activeflag=false,modifieduser=174744,modifieddate=now()
 where id in (select enrollrosterid from 
( select enrollrosterid,row_number() over(partition by studentid order by case when coalesce(statecoursecode,'')<>'' then 0 else 10 end desc,enrollrosterid desc) row_num
 from tmp_active_roster_sci_fix tmp
 where st_status is null) a where row_num<>1);
 
commit; 

--================================================================================================================
--================================================================================================================
--2.1-- enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course
--ELA roster duplicate after the 
/*
--counts
select statesubjectareaid,count(*) from roster  r
where currentschoolyear=2017 and coalesce(statecoursecode,'')<>'' and activeflag is true
group by statesubjectareaid
order by 2 desc;

--  statesubjectareaid | count
-- --------------------+-------
--                   3 |  1624
--                 440 |  1619
--                 441 |   285
--                 437 |   113
--                 443 |    19
--                 448 |     8
-- (6 rows)
-- 

select statesubjectareaid,count(*) from roster  r
where currentschoolyear=2017 and coalesce(statecoursecode,'')<>'' and activeflag is true
group by statesubjectareaid
order by 2 desc;


--  statesubjectareaid | count
-- --------------------+-------
--                   3 |  1351
--                 440 |  1331
--                 441 |   197
--                 437 |    47
--                 443 |    14
--                 448 |     1
-- (6 rows)



select statecoursecode,count(*)  from roster r 
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017 and coalesce(r.statecoursecode,'')<>''
group by statecoursecode;

*/



drop table if exists tmp_roster_ela;
with oth_roster as (
select tmp.statename,s.id studentid,r.id rosterid,statesubjectareaid,statecoursecode
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and s.activeflag is true and sap.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017 and coalesce(r.statecoursecode,'')<>'' and sap.assessmentprogramid=3 and statesubjectareaid=3)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.activeflag enrollactive,e.id enrollid,er.activeflag,er.id enrollrosterid   into temp tmp_roster_ela from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where r.currentschoolyear=2017 and r.statesubjectareaid=3 and r.createduser<>13
-- group by s.studentid,r.statesubjectareaid,r.id,r.statecoursecode
-- order by noof_cnt desc;
;

drop table if exists oth_roster_ela;
select *  into temp oth_roster_ela from tmp_roster_ela tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=3
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid
order by tmp.studentid;

\copy (select * from oth_roster_ela ) to 'oth_roster_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select *  
 from oth_roster_ela tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null;


 
select distinct studentid,rosterid,enrollid,ts_rosterid  
 from oth_roster_ela tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null;


select ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;


select count(*) from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

 select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,(
 select categorycode from category where id=st.status),
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status,
 case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

begin;
--make sure follow the dependency

update studentstestsections sts
set statusid=tmp.st_status,modifieduser =174744,modifieddate=now(),activeflag=true
from ( select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,
      case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp
 where tmp.studentstestsid=sts.studentstestid;

update studentstests st
set    enrollmentid = tmp.enrollid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status= tmp.st_status
from (select distinct st.id,tmp.rosterid,tmp.ts_rosterid,tmp.enrollid,st.studentid,
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status
  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.id=st.id and st.studentid=tmp.studentid;



update ititestsessionhistory iti
set    rosterid=tmp.rosterid,
       modifieddate =now(),studentenrlrosterid=tmp.enrollrosterid,status=84,activeflag=true,
       modifieduser =174744
from (select ts.id,tmp.rosterid,tmp.ts_rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.studentid=iti.studentid 
 and iti.rosterid=tmp.ts_rosterid and tmp.id=iti.testsessionid;


update testsession ts
set    rosterid =tmp.rosterid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status=84	
from (select ts.id,tmp.rosterid,tmp.ts_rosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
 where tmp.id=ts.id and ts.rosterid=tmp.ts_rosterid;

COMMIT; 

--2.2-- enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course
--M roster duplicate after the 

drop table if exists tmp_roster_m;
with oth_roster as (
select statename,s.id studentid,r.id rosterid,statesubjectareaid,statecoursecode
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and s.activeflag is true and sap.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017 and coalesce(r.statecoursecode,'')<>'' and sap.assessmentprogramid=3 and statesubjectareaid=440)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.activeflag enrollactive,e.id enrollid,er.activeflag,er.id enrollrosterid   into temp tmp_roster_m from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where r.currentschoolyear=2017 and r.statesubjectareaid=440 and r.createduser<>13
-- group by s.studentid,r.statesubjectareaid,r.id,r.statecoursecode
-- order by noof_cnt desc;
;

drop table if exists oth_roster_m;
select *  into temp oth_roster_m from tmp_roster_m tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=440
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid
order by tmp.studentid;

\copy (select * from oth_roster_m ) to 'oth_roster_m.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select *  
 from oth_roster_m tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


 
select distinct studentid,rosterid,enrollid,ts_rosterid  
 from oth_roster_m tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


select ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;


select count(*) from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

 select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,(
 select categorycode from category where id=st.status),
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status,
 case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

begin;
--make sure follow the dependency

update studentstestsections sts
set statusid=tmp.st_status,modifieduser =174744,modifieddate=now(),activeflag=true
from ( select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,
      case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp
 where tmp.studentstestsid=sts.studentstestid;

update studentstests st
set    enrollmentid = tmp.enrollid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status= tmp.st_status
from (select distinct st.id,tmp.rosterid,tmp.ts_rosterid,tmp.enrollid,st.studentid,
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status
  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.id=st.id and st.studentid=tmp.studentid;



update ititestsessionhistory iti
set    rosterid=tmp.rosterid,
       modifieddate =now(),studentenrlrosterid=tmp.enrollrosterid,status=84,activeflag=true,
       modifieduser =174744
from (select ts.id,tmp.rosterid,tmp.ts_rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.studentid=iti.studentid 
 and iti.rosterid=tmp.ts_rosterid and tmp.id=iti.testsessionid;


update testsession ts
set    rosterid =tmp.rosterid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status=84	
from (select ts.id,tmp.rosterid,tmp.ts_rosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_m tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
 where tmp.id=ts.id and ts.rosterid=tmp.ts_rosterid;

COMMIT; 

--2.3-- enrolled in two rosters( OTH and without other)
--Duplicate by roster after removing the course
--sci roster duplicate after the (None of the row impact for sci)

drop table if exists tmp_roster_sci;
with oth_roster as (
select statename,s.id studentid,r.id rosterid,statesubjectareaid,statecoursecode
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and s.activeflag is true and sap.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017 and coalesce(r.statecoursecode,'')<>'' and sap.assessmentprogramid=3 and statesubjectareaid=441)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.activeflag enrollactive,e.id enrollid,er.activeflag,er.id enrollrosterid  into temp tmp_roster_sci from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where r.currentschoolyear=2017 and r.statesubjectareaid=441 and r.createduser<>13
-- group by s.studentid,r.statesubjectareaid,r.id,r.statecoursecode
-- order by noof_cnt desc;
;

drop table if exists oth_roster_sci;
select *  into temp oth_roster_sci from tmp_roster_sci tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=441
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid
order by tmp.studentid;

\copy (select * from oth_roster_sci ) to 'oth_roster_sci.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select *  
 from oth_roster_sci tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


 
select distinct studentid,rosterid,enrollid,ts_rosterid  
 from oth_roster_sci tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


select ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;


select count(*) from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,(
 select categorycode from category where id=st.status),
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status,
 case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

begin;
--make sure follow the dependency

update studentstestsections sts
set statusid=tmp.st_status,modifieduser =174744,modifieddate=now(),activeflag=true
from ( select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,
      case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp
 where tmp.studentstestsid=sts.studentstestid;

update studentstests st
set    enrollmentid = tmp.enrollid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status= tmp.st_status
from (select distinct st.id,tmp.rosterid,tmp.ts_rosterid,tmp.enrollid,st.studentid,
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status
  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.id=st.id and st.studentid=tmp.studentid;



update ititestsessionhistory iti
set    rosterid=tmp.rosterid,
       modifieddate =now(),studentenrlrosterid=tmp.enrollrosterid,status=84,activeflag=true,
       modifieduser =174744
from (select ts.id,tmp.rosterid,tmp.ts_rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.studentid=iti.studentid 
 and iti.rosterid=tmp.ts_rosterid and tmp.id=iti.testsessionid;


update testsession ts
set    rosterid =tmp.rosterid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status=84	
from (select ts.id,tmp.rosterid,tmp.ts_rosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_roster_sci tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
 where tmp.id=ts.id and ts.rosterid=tmp.ts_rosterid;

COMMIT; 


--================================================================================================================
--3.1-- EXIT UNENROLLED enrolled in two rosters  --ela

select count(*) from tmp_reactivated_ids;

drop table if exists tmp_rosterexit_ela;
with oth_roster as (
select tmp.statename,s.id studentid,r.id rosterid,statesubjectareaid,statecoursecode
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join (select distinct studentid::bigint  studentid from tmp_reactivated_ids where studentid is not null ) ext on ext.studentid=s.id
inner join studentassessmentprogram sap on sap.studentid=s.id and s.activeflag is true and sap.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017  and sap.assessmentprogramid=3 and statesubjectareaid=3)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.activeflag enrollactive,e.id enrollid,er.activeflag,er.id enrollrosterid   into temp tmp_rosterexit_ela from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where r.currentschoolyear=2017 and r.statesubjectareaid=3 and r.createduser<>13
-- group by s.studentid,r.statesubjectareaid,r.id,r.statecoursecode
-- order by noof_cnt desc;
;

drop table if exists oth_rosterexit_ela;
select *  into temp oth_rosterexit_ela from tmp_rosterexit_ela tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=3
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid
order by tmp.studentid;

\copy (select * from oth_rosterexit_ela ) to 'oth_rosterexit_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select *  
 from oth_rosterexit_ela tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


 
select distinct studentid,rosterid,enrollid,ts_rosterid  
 from oth_rosterexit_ela tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;



select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,(
 select categorycode from category where id=st.status),
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status,
 case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

select count(*) from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

begin;
--make sure follow the dependency

update studentstestsections sts
set statusid=tmp.st_status,modifieduser =174744,modifieddate=now(),activeflag=true
from ( select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,
      case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp
 where tmp.studentstestsid=sts.studentstestid;

update studentstests st
set    enrollmentid = tmp.enrollid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status= tmp.st_status
from (select distinct st.id,tmp.rosterid,tmp.ts_rosterid,tmp.enrollid,st.studentid,
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status
  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.id=st.id and st.studentid=tmp.studentid;



update ititestsessionhistory iti
set    rosterid=tmp.rosterid,
       modifieddate =now(),studentenrlrosterid=tmp.enrollrosterid,status=84,activeflag=true,
       modifieduser =174744
from (select ts.id,tmp.rosterid,tmp.ts_rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.studentid=iti.studentid 
 and iti.rosterid=tmp.ts_rosterid and tmp.id=iti.testsessionid;


update testsession ts
set    rosterid =tmp.rosterid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status=84	
from (select ts.id,tmp.rosterid,tmp.ts_rosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_ela tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
 where tmp.id=ts.id and ts.rosterid=tmp.ts_rosterid;

COMMIT; 
--================================================================================================================
--3.2-- EXIT UNENROLLED enrolled in two rosters  --math

select count(*) from tmp_reactivated_ids;

drop table if exists tmp_rosterexit_math;
with oth_roster as (
select tmp.statename,s.id studentid,r.id rosterid,statesubjectareaid,statecoursecode
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join (select distinct studentid::bigint  studentid from tmp_reactivated_ids where studentid is not null ) ext on ext.studentid=s.id
inner join studentassessmentprogram sap on sap.studentid=s.id and s.activeflag is true and sap.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where --e.activeflag is true and er.activeflag is true and r.activeflag is true and 
r.currentschoolyear=2017  and sap.assessmentprogramid=3 and statesubjectareaid=440)
select tmp.statename,s.studentid,r.statesubjectareaid,r.id rosterid,r.statecoursecode,e.activeflag enrollactive,e.id enrollid,er.activeflag,er.id enrollrosterid   into temp tmp_rosterexit_math from enrollment e 
inner join oth_roster s on s.studentid=e.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid 
inner join roster r on r.id=er.rosterid
where r.currentschoolyear=2017 and r.statesubjectareaid=440 and r.createduser<>13
-- group by s.studentid,r.statesubjectareaid,r.id,r.statecoursecode
-- order by noof_cnt desc;
;

drop table if exists oth_rosterexit_math;
select *  into temp oth_rosterexit_math from tmp_rosterexit_math tmp
left outer join (select st.studentid st_studentid,st.status st_status,ts.rosterid ts_rosterid,count(*) st_cnt
from studentstests st
inner join test t on t.id=st.testid
inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 and source='ITI'
left outer join testcollection tc on tc.id=st.testcollectionid
where tc.contentareaid=440
group by st.studentid,st.status,ts.rosterid) st on tmp.studentid=st.st_studentid
order by tmp.studentid;

\copy (select * from oth_rosterexit_math ) to 'oth_rosterexit_math.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select *  
 from oth_rosterexit_math tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;


 
select distinct studentid,rosterid,enrollid,ts_rosterid  
 from oth_rosterexit_math tmp
 where ts_rosterid<>rosterid and activeflag is true and enrollactive is true and st_status is not null and st.status<>533;



select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,(
 select categorycode from category where id=st.status),
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status,
 case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

select count(*) from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533;

begin;
--make sure follow the dependency

update studentstestsections sts
set statusid=tmp.st_status,modifieduser =174744,modifieddate=now(),activeflag=true
from ( select distinct ts.id,tmp.rosterid,tmp.ts_rosterid,ts.rosterid,st.studentid,st.id studentstestsid,enrollrosterid,st.status,
      case when st.status in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 1) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
     when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TESTSECTION_STATUS'))
       else st.status end st_status    
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp
 where tmp.studentstestsid=sts.studentstestid;

update studentstests st
set    enrollmentid = tmp.enrollid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status= tmp.st_status
from (select distinct st.id,tmp.rosterid,tmp.ts_rosterid,tmp.enrollid,st.studentid,
case when st.status not in (84,85,86) then (select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=st.status)) 
     and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS'))  else st.status end st_status
  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.id=st.id and st.studentid=tmp.studentid;



update ititestsessionhistory iti
set    rosterid=tmp.rosterid,
       modifieddate =now(),studentenrlrosterid=tmp.enrollrosterid,status=84,activeflag=true,
       modifieduser =174744
from (select ts.id,tmp.rosterid,tmp.ts_rosterid,st.studentid,enrollrosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
where tmp.studentid=iti.studentid 
 and iti.rosterid=tmp.ts_rosterid and tmp.id=iti.testsessionid;


update testsession ts
set    rosterid =tmp.rosterid,
       modifieddate =now(),
       modifieduser =174744,
       activeflag=true,
       status=84	
from (select ts.id,tmp.rosterid,tmp.ts_rosterid  from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.source='ITI'
inner join oth_rosterexit_math tmp on tmp.studentid=st.studentid and ts.rosterid=tmp.ts_rosterid
 where tmp.ts_rosterid<>tmp.rosterid and tmp.activeflag is true and tmp.enrollactive is true and st_status is not null and st.status<>533) tmp 
 where tmp.id=ts.id and ts.rosterid=tmp.ts_rosterid;

COMMIT; 


--================================================================================================================
--final update to remove the couses

\copy (select * from roster where activeflag is true and currentschoolyear=2017 and coalesce(statecoursecode,'')<>'' ) to 'course_rosters.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select statecoursecode,statecoursesid,count(*)
from roster where activeflag is true and currentschoolyear=2017 
group by statecoursecode,statecoursesid;

begin;

update roster 
set statecoursecode=null,
    statecoursesid=null,
    modifieddate=now()
where activeflag is true and currentschoolyear=2017 and coalesce(statecoursecode,'')<>'';
commit;
--================================================================================================================


--================================================================================================================
--final update to remove the couses

\copy (select * from roster where activeflag is true and currentschoolyear=2017 and coalesce(statecoursecode,'')<>'' ) to 'course_rosters.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select statecoursecode,statecoursesid,count(*)
from roster where activeflag is true and currentschoolyear=2017 
group by statecoursecode,statecoursesid;

begin;

update roster 
set statecoursecode=null,
    statecoursesid=null,
    modifieddate=now()
where activeflag is true and currentschoolyear=2017 and coalesce(statecoursecode,'')<>'';
commit;
--================================================================================================================

--only on stage 

begin;

select count(*) from ititestsessionhistory iti
inner join (select iti.id,er.id studentenrlroster_id
from ititestsessionhistory iti
inner join testsession ts on ts.id=iti.testsessionid 
inner join studentstests st on st.testsessionid=ts.id
inner join enrollmentsrosters er on er.enrollmentid=st.enrollmentid and st.studentid=iti.studentid and er.rosterid=ts.rosterid 
where iti.modifieduser =174744) tmp 
on tmp.id=iti.id and iti.modifieduser =174744 and studentenrlrosterid<>studentenrlroster_id ;

select count(*) from ititestsessionhistory iti
where iti.modifieduser =174744;

update ititestsessionhistory iti
set studentenrlrosterid=studentenrlroster_id,modifieddate=now()
from (select iti.id,er.id studentenrlroster_id
from ititestsessionhistory iti
inner join testsession ts on ts.id=iti.testsessionid 
inner join studentstests st on st.testsessionid=ts.id
inner join enrollmentsrosters er on er.enrollmentid=st.enrollmentid and st.studentid=iti.studentid and er.rosterid=ts.rosterid 
where iti.modifieduser =174744) tmp 
where tmp.id=iti.id and iti.modifieduser =174744 and studentenrlrosterid<>studentenrlroster_id;




commit;


/*
select * from enrollment where studentid=917424;
select * from enrollmentsrosters where enrollmentid in (select id from enrollment where studentid=917424);
select * from roster where id in (select rosterid from enrollmentsrosters where enrollmentid in (select id from enrollment where studentid=917424)) and statesubjectareaid=3;
select studentid,enrollmentid,status,activeflag,modifieddate,modifieduser,testsessionid,testid from studentstests where studentid =917424 order by status;
select rosterid,name,activeflag,modifieddate,modifieduser,source from testsession where id in (select testsessionid from studentstests where studentid =917424);


select noof_cnt,count(*) from tmp_roster_ela group by noof_cnt;

select count(distinct rosterid) from tmp_roster_ela  where noof_cnt=1 group by noof_cnt;


select noof_cnt,count(*) from tmp_roster_ela tmp
inner join roster r on r.id=tmp.rosterid
group by noof_cnt;

--  cnt | count
-- -----+-------
--    2 |   324
--    1 |  4795
--    3 |    28
-- (3 rows)

select count(distinct r.*) from tmp_roster_ela tmp
inner join roster r on r.id=tmp.rosterid
where r.currentschoolyear=2017 and coalesce(r.statecoursecode,'')<>''  and r.statesubjectareaid=3
and noof_cnt=1;

with dups as (
select 
attendanceschoolid,
teacherid,
statesubjectareaid,
aypschoolid,
count(*) from roster r
where activeflag is true and currentschoolyear=2017
group by 
attendanceschoolid,
teacherid,
statesubjectareaid,
aypschoolid
having count(*)>1)
select r.* 
into temp tmp_dualroster from dups d
inner join roster r 
on r.attendanceschoolid=d.attendanceschoolid
 and r.teacherid=d.teacherid
 and r.statesubjectareaid=d.statesubjectareaid
 and r.aypschoolid=d.aypschoolid;


--duplicated by aypschool/attendanceschoolid/teacher/subject/course
with dups as (
select 
r.attendanceschoolid,
r.teacherid,
r.statesubjectareaid,
r.aypschoolid,
count(r.id) from roster r
inner join roster d 
on r.attendanceschoolid=d.attendanceschoolid
 and r.teacherid=d.teacherid
 and r.statesubjectareaid=d.statesubjectareaid
 and r.aypschoolid=d.aypschoolid where d.activeflag is true and d.currentschoolyear=2017 and coalesce(d.statecoursecode,'')<>''
and r.activeflag is true and r.currentschoolyear=2017
group by 
r.attendanceschoolid,
r.teacherid,
r.statesubjectareaid,
r.aypschoolid
having count(r.id)>1)
select r.* 
into temp tmp_dualroster from dups d
inner join roster r 
on r.attendanceschoolid=d.attendanceschoolid
 and r.teacherid=d.teacherid
 and r.statesubjectareaid=d.statesubjectareaid
 and r.aypschoolid=d.aypschoolid
 where r.activeflag is true and r.currentschoolyear=2017 ;


\copy (select * from tmp_dualroster order by teacherid,statesubjectareaid) to 'tmp_dualroster.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--  RAISE NOTICE 'Validation(3) Student actively enrolled in two schools for same subject total count:%',row_count;
select s.id,s.statestudentidentifier ssid,statesubjectareaid,count(distinct e.id)
from enrollment e
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true
group by  s.id,s.statestudentidentifier,statesubjectareaid
having count(distinct e.id)>1 order by s.id desc limit 5

*/




--================================================================================================================

select count(id) from studentstests sts
where  sts.modifieduser =174744 and sts.modifieddate::date='2017-03-08'

begin;
-- iti

update ititestsessionhistory
set activeflag=true,modifieduser =174744 -- and modifieddate=now()
,status=84
where  modifieduser =174744 and modifieddate::date='2017-03-08'
and activeflag=false and status in (84,654,649);

select status,activeflag,count(*) from ititestsessionhistory
where modifieduser =174744 and modifieddate::date='2017-03-08'
group by status,activeflag;

commit;


begin;
select status,activeflag,count(*) from testsession
where modifieduser =174744 and modifieddate::date='2017-03-08'
group by status,activeflag;

update testsession
set  status=84
where  modifieduser =174744 and modifieddate::date='2017-03-08'
and status in (654,649);

commit;
begin;
select status,activeflag,count(*) from ititestsessionhistory
where modifieduser =174744 and modifieddate::date='2017-03-08'
group by status,activeflag;

update testsession
set  status=84
where  modifieduser =174744 and modifieddate::date='2017-03-08'
and status in (654,649);

commit;
select status,activeflag,count(*) from ititestsessionhistory
where modifieduser =174744 and modifieddate::date='2017-03-08'
group by status,activeflag;
commit;


select status,activeflag,count(*) from ititestsessionhistory
where modifieduser =174744 and modifieddate::date='2017-03-08'
group by status,activeflag


select distinct ts.status, ts.activeflag from studentstests sts join testsession ts on ts.id = sts.testsessionid
where  sts.modifieduser =174744 and sts.modifieddate::date='2017-03-08'



from studentstestsections sts
where  statusid in (656,651,655) and  sts.modifieduser =174744 and sts.modifieddate::date='2017-03-08'


-- select sts.statusid,sts.activeflag,count(sts.id),(select id from category where categorycode =(select (select split_part(categorycode, '-', 2) from category where id=sts.statusid)) 
--       and categorytypeid = (select id from categorytype where typecode = 'STUDENT_TEST_STATUS')) stsstatus
--  from studentstests st
-- inner join studentstestsections sts on sts.studentstestid=st.id 
-- where st.modifieduser =174744 and st.modifieddate::date='2017-03-08'
-- -- and statusid in (656,651,655) 
-- group by sts.statusid,sts.activeflag,stsstatus


begin;

select sts.statusid,sts.activeflag,count(*) from studentstests st
inner join studentstestsections sts on sts.studentstestid=st.id 
where st.modifieduser =174744 and st.modifieddate::date='2017-03-08'
group by sts.statusid,sts.activeflag;

update studentstestsections 
set statusid=125,modifieduser =174744,modifieddate=now(),activeflag=true
where id in (select sts.id
 from studentstests st
inner join studentstestsections sts on sts.studentstestid=st.id 
where st.modifieduser =174744 and st.modifieddate::date='2017-03-08')
and activeflag is false and statusid in (656,651);

update studentstests
set status=85
where id=15083022;

update studentstestsections 
set statusid=126,modifieduser =174744,modifieddate=now(),activeflag=true
where id in (select sts.id
 from studentstests st
inner join studentstestsections sts on sts.studentstestid=st.id 
where st.modifieduser =174744 and st.modifieddate::date='2017-03-08')
and activeflag is false and statusid in (655);


commit;







--iti activefla and ststua by lookup,
-- testsession status and activeflag is true
-- students status and activeflag is true.
-- student test sec status,activeflag true

	