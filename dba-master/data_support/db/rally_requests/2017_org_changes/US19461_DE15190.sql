select distinct ts.id testsessionid,teacherid,r.id rosterid,er.rosterid,e.activeflag enrollactive,er.activeflag enrollroster
,er.modifieddate enrollroster,ts.modifieddate sessions,ts.name from studentstests st
inner join enrollment e on e.id =st.enrollmentid 
inner join enrollmentsrosters er on e.id =er.enrollmentid 
inner join student s on s.id =e.studentid 
inner join testsession ts on st.testsessionid=ts.id
inner join roster r on r.id=ts.rosterid
where e.currentschoolyear =2017 and s.id=855795 and st.activeflag is true and st.status=86 and r.statesubjectareaid=3 
and er.rosterid in  (1102610,1080078)  
order by er.rosterid;

--ela subject 

begin;
drop table if exists tmp_dualroster_ela;
select distinct s.id,ts.rosterid sessionroster,r.id enrollrosterid,e.activeflag enrollactive,er.activeflag enrollrosteract,e.modifieddate enroll,
er.modifieddate enrollroster,ts.id testsessionid,ts.modifieddate sessions,st.modifieddate test,ts.name,r.coursesectionname
into temp tmp_dualroster_ela
from studentstests st 
inner join test t on t.id=st.testid 	
inner join enrollment e on e.id =st.enrollmentid and e.currentschoolyear=2017
inner join enrollmentsrosters er on e.id =er.enrollmentid 
inner join student s on s.id =e.studentid 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true and assessmentprogramid=3 
inner join testsession ts on st.testsessionid=ts.id and e.currentschoolyear=2017
inner join roster r on r.id=er.rosterid
where e.currentschoolyear =2017 and st.activeflag is true and st.status=86 and r.statesubjectareaid=t.contentareaid
and ts.schoolyear=2017 and ts.activeflag is true and r.statesubjectareaid=3
and ts.rosterid<>r.id
order by s.id,r.id;
\copy (select * from tmp_dualroster_ela) to 'tmp_dualroster_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


update testsession ts
set    rosterid=tmp.enrollrosterid,
       modifieddate =now(),
	   modifieduser=12
from (select distinct enrollrosterid,testsessionid from tmp_dualroster_ela where enrollrosteract is true and id not in (234882,857233,1324708) ) tmp
where tmp.testsessionid=ts.id;

update ititestsessionhistory ts
set    rosterid=tmp.enrollrosterid,
       modifieddate =now(),
	   modifieduser=12
from (select distinct enrollrosterid,testsessionid from tmp_dualroster_ela where enrollrosteract is true and id not in (234882,857233,1324708)) tmp
where tmp.testsessionid=ts.testsessionid;

commit;

begin;
drop table if exists tmp_dualroster_m;
select distinct s.id,ts.rosterid sessionroster,r.id enrollrosterid,e.activeflag enrollactive,er.activeflag enrollrosteract,e.modifieddate enroll,
er.modifieddate enrollroster,ts.id testsessionid,ts.modifieddate sessions,st.modifieddate test,ts.name,r.coursesectionname
into temp tmp_dualroster_m
from studentstests st 
inner join test t on t.id=st.testid 	
inner join enrollment e on e.id =st.enrollmentid and e.currentschoolyear=2017
inner join enrollmentsrosters er on e.id =er.enrollmentid 
inner join student s on s.id =e.studentid 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true and assessmentprogramid=3 
inner join testsession ts on st.testsessionid=ts.id and e.currentschoolyear=2017
inner join roster r on r.id=er.rosterid
where e.currentschoolyear =2017 and st.activeflag is true and st.status=86 and r.statesubjectareaid=t.contentareaid
and ts.schoolyear=2017 and ts.activeflag is true and r.statesubjectareaid=440
and ts.rosterid<>r.id
order by s.id,r.id;
\copy (select * from tmp_dualroster_m) to 'tmp_dualroster_m.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

update testsession ts
set    rosterid=tmp.enrollrosterid,
       modifieddate =now(),
	   modifieduser=12
from (select distinct enrollrosterid,testsessionid from tmp_dualroster_m where enrollrosteract is true and id not in (1324708)) tmp
where tmp.testsessionid=ts.id;

update ititestsessionhistory ts
set    rosterid=tmp.enrollrosterid,
       modifieddate =now(),
	   modifieduser=12
from (select distinct enrollrosterid,testsessionid from tmp_dualroster_m where enrollrosteract is true and id not in (1324708)) tmp
where tmp.testsessionid=ts.testsessionid;

commit;

create temp table tmp_orgyear (orgid bigint ,orgyear int);
insert into tmp_orgyear
select schoolid orgid,2017 orgyear from organizationtreedetail 
where coalesce(organization_school_year(stateid),extract(year from now()))=2017 
and stateid not in (select id from organization where  organizationtypeid=2 
and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland'));

select studentid,statesubjectareaid,count(distinct er.id)
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where e.activeflag is true and er.activeflag is true and r.activeflag is true
and s.id=1324708
group by  studentid,statesubjectareaid
having count(distinct er.id)>1

select distinct
r.currentschoolyear,o.statename,o.districtname,o.schoolname,r.id,r.coursesectionname,r.statesubjectareaid,
r.statecoursecode,r.statecourseid ,r.modifieddate, r.modifieduser,r.createddate,r.createduser
into temp tmp_rosters
from roster r 
inner join (select statesubjectareaid,teacherid,attendanceschoolid,count(*) from roster where currentschoolyear=2017 and activeflag is true group by statesubjectareaid,teacherid,attendanceschoolid having count(*)>1) tmp 
on tmp.statesubjectareaid=r.statesubjectareaid and tmp.teacherid=r.teacherid and tmp.attendanceschoolid=r.attendanceschoolid
inner join organizationtreedetail o on o.schoolid=r.attendanceschoolid
where r.currentschoolyear=2017
order by o.statename,o.districtname,o.schoolname,r.statesubjectareaid;    

\copy (select * from tmp_rosters) to 'tmp_rosters.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select distinct
r.currentschoolyear,o.statename,o.districtname,o.schoolname,r.id,r.coursesectionname,r.statesubjectareaid,
r.statecoursecode,r.statecourseid ,r.modifieddate, r.modifieduser,r.createddate,r.createduser
into temp tmp_rosters
from roster r 
inner join (select statesubjectareaid,teacherid,attendanceschoolid,coursesectionname,count(*) from roster where currentschoolyear=2017 and activeflag is true group by statesubjectareaid,teacherid,attendanceschoolid,coursesectionname having count(*)>1) tmp 
on tmp.statesubjectareaid=r.statesubjectareaid and tmp.teacherid=r.teacherid and tmp.attendanceschoolid=r.attendanceschoolid 
and tmp.coursesectionname=r.coursesectionname
inner join organizationtreedetail o on o.schoolid=r.attendanceschoolid
where r.currentschoolyear=2017
order by o.statename,o.districtname,o.schoolname,r.statesubjectareaid;    

\copy (select * from tmp_rosters) to 'tmp_rosters.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);




select r.statesubjectareaid,s.id,count(distinct er.id)
 into temp dup_enroll
from student s 
inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true
INner join roster r on er.rosterid=r.id and r.activeflag is true
group by r.statesubjectareaid,s.id
having count(distinct er.id)>1;


select statename,districtname,schoolname,e.studentid,s.statestudentidentifier ssid,e.currentschoolyear,
er.id enrollrosterid,r.coursesectionname,r.statesubjectareaid,statecoursecode,statecourseid,e.createddate enrollcreated,e.modifieddate enrollmod,er.createddate enrollrostercreated,er.modifieddate enrollrostermod, 
testscount,tmpst.status,r.createddate rostercreated,r.modifieddate rostermod
into temp dailyvalidation3
from enrollment e 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join organizationtreedetail o on o.schoolid=e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid
inner join roster r on r.id=er.rosterid and r.currentschoolyear=2017 
inner join dup_enroll dup on dup.id=s.id and dup.statesubjectareaid=r.statesubjectareaid
left outer join (select enrollmentid,st.status,count(*) testscount from studentstests st 
 inner join testsession ts on st.testsessionid=ts.id and schoolyear=2017 where st.activeflag is true and ts.activeflag is true
 and st.status in (86,84,85) 
 group by enrollmentid,st.status) tmpst on tmpst.enrollmentid=e.id;

\copy (select * from dailyvalidation3 ) to 'dailyvalidation3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
