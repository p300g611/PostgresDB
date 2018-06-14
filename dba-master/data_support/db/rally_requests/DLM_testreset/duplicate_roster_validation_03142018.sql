/*
select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname, statesubjectareaid,teacherid,r.attendanceschoolid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=1438242
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source,ts.attendanceschoolid
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1438242 order by contentareaid,enrollmentid,rosterid;

*/

--==================================================================================
--student:45075
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1250207,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =45075) and rosterid=1184933;

update ititestsessionhistory
set    rosterid=1250207,
       studentenrlrosterid=16394122,
       modifieddate =now(),
       modifieduser =174744
where studentid =45075 and rosterid=1184933;

-- update studentstests 
-- set    enrollmentid = 2927923,
--        modifieddate =now(),
--        modifieduser =174744,
--        manualupdatereason='Ticket Number#1000'
-- where studentid =45075 and enrollmentid =2595962 ;

--Math

update testsession 
set    rosterid =1250208,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =45075) and rosterid=1184937;

update ititestsessionhistory
set    rosterid=1250208,
       studentenrlrosterid=16394123,
       modifieddate =now(),
       modifieduser =174744
       --,attendanceschoolid=0000000000
where studentid =45075 and rosterid=1184937;


-- update studentstests 
-- set    enrollmentid = 2927923,
--        modifieddate =now(),
--        modifieduser =174744,
--        manualupdatereason='Ticket Number#1000'
-- where studentid =45075 and enrollmentid =45075 ;


commit;

--==================================================================================

--==================================================================================
--student:1438242
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1240019,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1438242) and rosterid=1238096;

update ititestsessionhistory
set    rosterid=1240019,
       studentenrlrosterid=16312975,
       modifieddate =now(),
       modifieduser =174744
where studentid =1438242 and rosterid=1238096;


--Math

update testsession 
set    rosterid =1240020,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1438242) and rosterid=1238113;

update ititestsessionhistory
set    rosterid=1240020,
       studentenrlrosterid=16312976,
       modifieddate =now(),
       modifieduser =174744
       --,attendanceschoolid=0000000000
where studentid =1438242 and rosterid=1238113;

-- OTH 

update testsession 
set    rosterid =1240020,
       modifieddate =now(),
       modifieduser =174744,
       attendanceschoolid=85154
where id in (select testsessionid from studentstests where studentid =1438242) and rosterid=1193186 and id=5652155;



commit;

--==================================================================================
--==================================================================================
--student:1415290
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1163506,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1415290) and rosterid=1163505;

update ititestsessionhistory
set    rosterid=1163506,
       studentenrlrosterid=16380451,
       modifieddate =now(),
       modifieduser =174744
where studentid =1415290 and rosterid=1163505;


--Math

update testsession 
set    rosterid =1163512,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1415290) and rosterid=1163511;

update ititestsessionhistory
set    rosterid=1163512,
       studentenrlrosterid=16380452,
       modifieddate =now(),
       modifieduser =174744
       --,attendanceschoolid=0000000000
where studentid =1415290 and rosterid=1163511;



commit;

--==================================================================================
--==================================================================================
--student:1415292
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1249080,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1415292) and rosterid=1163505;

update ititestsessionhistory
set    rosterid=1249080,
       studentenrlrosterid=16380451,
       modifieddate =now(),
       modifieduser =174744
where studentid =1415292 and rosterid=1163505;


--Math

update testsession 
set    rosterid =1249079,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1415292) and rosterid=1163511;

update ititestsessionhistory
set    rosterid=1249079,
       studentenrlrosterid=16380453,
       modifieddate =now(),
       modifieduser =174744
where studentid =1415292 and rosterid=1163511;



commit;

--==================================================================================
--==================================================================================
--student:1071127
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1243477,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1071127) and rosterid=1172540;

update ititestsessionhistory
set    rosterid=1243477,
       studentenrlrosterid=16330798,
       modifieddate =now(),
       modifieduser =174744
where studentid =1071127 and rosterid=1172540;


--Math

update testsession 
set    rosterid =1243476,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1071127) and rosterid=1172631;

update ititestsessionhistory
set    rosterid=1243476,
       studentenrlrosterid=16330797,
       modifieddate =now(),
       modifieduser =174744
where studentid =1071127 and rosterid=1172631;



commit;

--==================================================================================
--==================================================================================
--student:1436042
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1226537,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1436042) and rosterid=1193133;

update ititestsessionhistory
set    rosterid=1226537,
       studentenrlrosterid=16227615,
       modifieddate =now(),
       modifieduser =174744
where studentid =1436042 and rosterid=1193133;


--Math

update testsession 
set    rosterid =1228181,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1436042) and rosterid=1236702;

update ititestsessionhistory
set    rosterid=1228181,
       studentenrlrosterid=16366290,
       modifieddate =now(),
       modifieduser =174744
where studentid =1436042 and rosterid=1236702;



commit;

--==================================================================================

--==================================================================================
--student:1438239
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1240022,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1438239) and rosterid=1193147;

update ititestsessionhistory
set    rosterid=1240022,
       studentenrlrosterid=16312978,
       modifieddate =now(),
       modifieduser =174744
where studentid =1438239 and rosterid=1193147;


--Math

update testsession 
set    rosterid =1240023,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1438239) and rosterid=1238103;

update ititestsessionhistory
set    rosterid=1240023,
       studentenrlrosterid=16312979,
       modifieddate =now(),
       modifieduser =174744
where studentid =1438239 and rosterid=1238103;



commit;

--==================================================================================