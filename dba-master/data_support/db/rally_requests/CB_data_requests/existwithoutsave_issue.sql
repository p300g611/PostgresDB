---------------------------------------------------------------------------------------------
--final reports

select distinct ot.statename,ot.districtname,ot.schoolname,st.status,st.id studentstestsid,sts.id studentstestsectionsid,sr.taskvariantid,
s.id studentid,sr.foilid,score
into temp tmp_report
from studentstests  st 
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join student s on s.id=e.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where (sr.createddate::date>'2017-08-01' or sr.modifieddate::date>'2017-08-01')   and st.status=86 and sr.activeflag is false
and e.currentschoolyear=2018
order by ot.statename,ot.districtname,ot.schoolname;

\copy (select * from tmp_report) to 'tmp_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select ot.statename,ot.districtname,ot.schoolname,count(distinct s.id) noofstudents
into temp tmp_report_school
from studentstests  st 
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join student s on s.id=e.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where (sr.createddate::date>'2017-08-01' or sr.modifieddate::date>'2017-08-01')   and st.status=86 and sr.activeflag is false
and e.currentschoolyear=2018
group by ot.statename,ot.districtname,ot.schoolname
order by ot.statename,ot.districtname,ot.schoolname;


\copy (select * from tmp_report_school) to 'tmp_report_school.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


create temporary table tmp_exitwithoutsave_errors(studentid BIGINT, testid BIGINT, testsectionid BIGINT, studentstestsid BIGINT, studentstestsectionsid BIGINT, 
taskvariantid BIGINT,foilids BIGINT, response TEXT, score numeric(6,3), attempts TEXT, isLCS BOOLEAN, querydate timestamp with time zone); 

\copy tmp_exitwithoutsave_errors from 'exitwithoutsave.txt' DELIMITER ',' CSV HEADER;


select count(*) from (
select studentstestsectionsid,taskvariantid,count(*) from tmp_report
group by studentstestsectionsid,taskvariantid) a
having count(*)>1;

with dups as 
(select *, row_number() over (partition by studentstestsectionsid,taskvariantid order by querydate desc) row_num from tmp_exitwithoutsave_errors )
select count(*) from dups where row_num=1;

with dups as 
(select *, row_number() over (partition by studentstestsectionsid,taskvariantid order by querydate desc) row_num from tmp_exitwithoutsave_errors )
select tmp.studentid,tmp.studentstestsid,tmp.studentstestsectionsid,tmp.taskvariantid,
 tmp.foilid db_foilid,dups.foilids log_foilid,tmp.score db_score,dups.score log_score
 from tmp_report tmp
left outer join dups on tmp.studentstestsectionsid=dups.studentstestsectionsid and tmp.taskvariantid=dups.taskvariantid and row_num=1 



---------------------------------------------------------------------------------

select count(distinct st.studentid)
from studentstests  st 
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where ts.schoolyear=2018 and st.status=86 and sr.activeflag is false;



select count(distinct st.studentid)
from studentstests  st 
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where ts.schoolyear=2018  and sr.activeflag is false;

select ot.statename,st.status,count(distinct st.studentid)
from studentstests  st 
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where sr.modifieddate::date>'2017-08-01'  and sr.activeflag is false
and e.currentschoolyear=2018
group by ot.statename,st.status;


 select count(*) from (select distinct st.id,sr.activeflag from exitwithoutsavetest ews
inner join studentstestsections sts on sts.id = ews.studenttestsectionid
inner join studentstests st on st.id = sts.studentstestid
inner join student std on std.id = st.studentid
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
and e.currentschoolyear=2018
where ews.createddate>'2017-08-01' and st.status=86 and st.activeflag is true ) as temp;


group by ot.statename,st.status,ts.source;



select count(*) from (select distinct st.studentid from exitwithoutsavetest ews
inner join studentstestsections sts on sts.id = ews.studenttestsectionid
inner join studentstests st on st.id = sts.studentstestid
inner join student std on std.id = st.studentid
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
and e.currentschoolyear=2018
where ews.createddate>'2017-08-01' and st.status=86 and st.activeflag is true  and sr.activeflag is false  ) as temp;


select distinct sts.id,sr.taskvariantid
from studentstests  st 
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where sr.createddate::date>'2017-08-01' and st.status=86 and sr.activeflag is false
and e.currentschoolyear=2018;



       statename       | status | count
-----------------------+--------+-------
 Colorado              |     86 |     1
 DLM QC State          |     84 |     2
 DLM QC State          |     86 |     1
 Iowa                  |     84 |    32
 Iowa                  |     85 |     1
 Iowa                  |     86 |    42
 Iowa                  |    533 |     1
 Kansas                |     84 |    19
 Kansas                |     86 |    22
 Missouri              |     84 |    25
 Missouri              |     86 |    56
 North Dakota          |     86 |     1
 NY Training State     |     84 |    10
 Oklahoma              |     84 |     5
 Oklahoma              |     86 |     1
 Service Desk QC State |     84 |     1
(16 rows)


       statename       | status | count
-----------------------+--------+-------
 Colorado              |     86 |     1
 DLM QC State          |     84 |     2
 DLM QC State          |     86 |     1
 Iowa                  |     84 |    32
 Iowa                  |     85 |     1
 Iowa                  |     86 |    42
 Iowa                  |    533 |     1
 Kansas                |     84 |    19
 Kansas                |     86 |    22
 Missouri              |     84 |    25
 Missouri              |     86 |    56
 North Dakota          |     86 |     1
 NY Training State     |     84 |    10
 Oklahoma              |     84 |     5
 Oklahoma              |     86 |     1
 Service Desk QC State |     84 |     1
(16 rows)



select ot.statename,st.id stid,st.studentid
from studentstests  st 
inner join enrollment e on e.id=st.enrollmentid and st.studentid=e.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections  sts on st.id=sts.studentstestid
inner join testsession ts on st.testsessionid=ts.id
inner join studentsresponses sr on sts.id=sr.studentstestsectionsid
where sr.modifieddate::date>'2017-08-01'  and sr.activeflag is false
and e.currentschoolyear=2018
order by 1,3;
group by ot.statename,st.status;