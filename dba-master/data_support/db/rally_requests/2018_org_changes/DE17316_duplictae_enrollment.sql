/*
select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname, statesubjectareaid,teacherid,r.attendanceschoolid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=1206937
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source,ts.attendanceschoolid
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1206937 order by contentareaid,enrollmentid,rosterid;

*/

--==================================================================================
--student:1206937
--==================================================================================
begin;
--ELA

update ititestsessionhistory
set   -- rosterid=1185611,
       studentenrlrosterid=16454160,
       modifieddate =now(),
       modifieduser =174744
where studentid =1436262 and rosterid=1185611;

update studentstests 
set    enrollmentid = 3406981,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='DE17316'
where studentid =1436262 and enrollmentid =3124668
and id in (18994132,
18994043,
18994045,
18994193,
19470419,
18994061,
18994071,
18994186,
18994033);

--Math

update ititestsessionhistory
set   -- rosterid=1185611,
       studentenrlrosterid=16454160,
       modifieddate =now(),
       modifieduser =174744
where studentid =1436262 and rosterid=1185611;

update studentstests 
set    enrollmentid = 3406981,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='DE17316'
where studentid =1436262 and enrollmentid =3124668
and id in (18994132,
18994043,
18994045,
18994193,
19470419,
18994061,
18994071,
18994186,
18994033);
