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
update testsession 
set    rosterid =1178985,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=20018
where id in (select testsessionid from studentstests where studentid =1206937) and rosterid=1177744;

update ititestsessionhistory
set    rosterid=1178985,
       studentenrlrosterid=15781009,
       modifieddate =now(),
       modifieduser =174744
where studentid =1206937 and rosterid=1177744;

update studentstests 
set    enrollmentid = 2986882,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1206937 and enrollmentid =3269863;

--Math

update testsession 
set    rosterid =1174378,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=20018
where id in (select testsessionid from studentstests where studentid =1206937) and rosterid=1177745;

update ititestsessionhistory
set    rosterid=1174378,
       studentenrlrosterid=15721252,
       modifieddate =now(),
       modifieduser =174744
where studentid =1206937 and rosterid=1177745;


update studentstests 
set    enrollmentid = 2986882,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1206937 and enrollmentid =3269863;

--Sci

update testsession 
set    rosterid =1211506,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=20018
where id in (select testsessionid from studentstests where studentid =1206937) and rosterid=1179133;

update ititestsessionhistory
set    rosterid=1211506,
       studentenrlrosterid=16435950,
       modifieddate =now(),
       modifieduser =174744
where studentid =1206937 and rosterid=1179133;


update studentstests 
set    enrollmentid = 2986882,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1206937 and enrollmentid =3269863;

commit;

--==================================================================================
--student:1406068
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1256046,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=18158
where id in (select testsessionid from studentstests where studentid =1406068) and rosterid=1185379;

update ititestsessionhistory
set    rosterid=1256046,
       studentenrlrosterid=16436341,
       modifieddate =now(),
       modifieduser =174744
where studentid =1406068 and rosterid=1185379;

update studentstests 
set    enrollmentid = 3407377,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1406068 and enrollmentid =3082118;

--Math

update testsession 
set    rosterid =1256047,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=18158
where id in (select testsessionid from studentstests where studentid =1406068) and rosterid=1185381;

update ititestsessionhistory
set    rosterid=1256047,
       studentenrlrosterid=16436342,
       modifieddate =now(),
       modifieduser =174744
where studentid =1406068 and rosterid=1185381;


update studentstests 
set    enrollmentid = 3407377,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1406068 and enrollmentid =3082118;

--Sci

update testsession 
set    rosterid =1256048,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=18158
where id in (select testsessionid from studentstests where studentid =1406068) and rosterid=1185382;

update ititestsessionhistory
set    rosterid=1256048,
       studentenrlrosterid=16435950,
       modifieddate =now(),
       modifieduser =174744
where studentid =1406068 and rosterid=1185382;


update studentstests 
set    enrollmentid = 3407377,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1406068 and enrollmentid =3082118;

commit;

--==================================================================================
--student:1406070
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1256041,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=18158
where id in (select testsessionid from studentstests where studentid =1406070) and rosterid=1185379;

update ititestsessionhistory
set    rosterid=1256041,
       studentenrlrosterid=16436336,
       modifieddate =now(),
       modifieduser =174744
where studentid =1406070 and rosterid=1185379;

update studentstests 
set    enrollmentid = 3407395,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1406070 and enrollmentid =3082107;

--Math

update testsession 
set    rosterid =1256042,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=18158
where id in (select testsessionid from studentstests where studentid =1406070) and rosterid=1185381;

update ititestsessionhistory
set    rosterid=1256042,
       studentenrlrosterid=16436337,
       modifieddate =now(),
       modifieduser =174744
where studentid =1406070 and rosterid=1185381;


update studentstests 
set    enrollmentid = 3407395,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#620868'
where studentid =1406070 and enrollmentid =3082107;


commit;
