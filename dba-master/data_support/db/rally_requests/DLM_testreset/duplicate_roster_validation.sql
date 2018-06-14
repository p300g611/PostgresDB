/*
select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname, statesubjectareaid,teacherid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=1341818
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1341818 order by contentareaid,enrollmentid,rosterid;

*/



create temp table tmp_orgyear (orgid bigint ,orgyear int);
insert into tmp_orgyear
select schoolid orgid,2018 orgyear from organizationtreedetail 
where coalesce(organization_school_year(stateid),extract(year from now()))=2018
and stateid not in (select id from organization where  organizationtypeid=2 
and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland'));

select r.statesubjectareaid,s.id,count(distinct er.id)
from student s 
inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true
INner join roster r on er.rosterid=r.id and r.activeflag is true
where e.currentschoolyear=2018	
group by r.statesubjectareaid,s.id
having count(distinct er.id)>1;


select contentareaid,s.id,count(distinct ts.rosterid) 
from studentstests st 
inner join student s on s.id=st.studentid
inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
inner join testsession ts on ts.id=st.testsessionid
inner join testcollection tc on tc.id=ts.testcollectionid
where st.activeflag is true and st.status=86 and ts.activeflag is true and contentareaid in (441,440,3)
and ts.schoolyear=2018 and e.currentschoolyear=2018
group by contentareaid,s.id
having count(distinct ts.rosterid)>1;

/*
--  This is the scenario, student completed tests and transferred to new school, new-school tests in unused and old school tests not transferred for completed tests

select contentareaid,s.id,count(distinct ts.rosterid) 
from studentstests st 
inner join student s on s.id=st.studentid
inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
inner join testsession ts on ts.id=st.testsessionid
inner join testcollection tc on tc.id=ts.testcollectionid
where st.activeflag is true --and st.status=86
and ts.activeflag is true and contentareaid in (441,440,3)
and ts.schoolyear=2018
and exists (select 1 from studentstests st_in where st_in.status=86 and st_in.studentid=st.studentid)
group by contentareaid,s.id
having count(distinct ts.rosterid)>1;

*/

--==================================================================================
--student:1341818
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1140359,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=0000000000
where id in (select testsessionid from studentstests where studentid =1341818) and rosterid=1098343;

update ititestsessionhistory
set    rosterid=1140359,
       studentenrlrosterid=15592547,
       modifieddate =now(),
       modifieduser =174744
where studentid =1341818 and rosterid=1098343;

--Math

update testsession 
set    rosterid =1140360,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1341818) and rosterid=1098345;

update ititestsessionhistory
set    rosterid=1140360,
       studentenrlrosterid=15592548,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=0000000000
where studentid =1341818 and rosterid=1098345;


update studentstests 
set    enrollmentid = 2927923,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#1000'
where studentid =1341818 and enrollmentid =2595962 ;


commit;

--==================================================================================