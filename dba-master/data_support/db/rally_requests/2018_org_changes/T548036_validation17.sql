--==================================================================================
--student:1237386
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1256226,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=20644
where id in (select testsessionid from studentstests where studentid =1237386) and rosterid=1175218;

update ititestsessionhistory
set    rosterid=1256226,
       studentenrlrosterid=16436937,
       modifieddate =now(),
       modifieduser =174744
where studentid =1237386 and rosterid=1175218;

--Math

update testsession 
set    rosterid =1256227,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=20644
where id in (select testsessionid from studentstests where studentid =1237386) and rosterid=1175217;

update ititestsessionhistory
set    rosterid=1256227,
       studentenrlrosterid=16436938,
       modifieddate =now(),
       modifieduser =174744
where studentid =1237386 and rosterid=1175217;

--Sci
update testsession 
set    rosterid =1256228,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=20644
where id in (select testsessionid from studentstests where studentid =1237386) and rosterid=1175219;

update ititestsessionhistory
set    rosterid=1256228,
       studentenrlrosterid=16436939,
       modifieddate =now(),
       modifieduser =174744	   
where studentid =1237386 and rosterid=1175219;


update studentstests 
set    enrollmentid = 3407475,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#548036'
where studentid =1237386 and enrollmentid =2999806 ;

--==================================================================================
--student:1397790
--==================================================================================

--ELA
update testsession 
set    rosterid =1176127,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=19383
where id in (select testsessionid from studentstests where studentid =1397790) and rosterid=1185522;

update ititestsessionhistory
set    rosterid=1176127,
       studentenrlrosterid=16436967,
       modifieddate =now(),
       modifieduser =174744
where studentid =1397790 and rosterid=1185522;

--Math

update testsession 
set    rosterid =1176126,
       modifieddate =now(),
       modifieduser =174744,
	   attendanceschoolid=19383
where id in (select testsessionid from studentstests where studentid =1397790) and rosterid=1185523;

update ititestsessionhistory
set    rosterid=1176126,
       studentenrlrosterid=16436969,
       modifieddate =now(),
       modifieduser =174744
where studentid =1397790 and rosterid=1185523;


update studentstests 
set    enrollmentid = 3407480,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#548036'
where studentid =1397790 and enrollmentid =3085874 ;
commit;