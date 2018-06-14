--SSID:5157631022 
begin;
--ELA
update testsession 
set    rosterid =1231388,
       modifieddate =now(),
       modifieduser =174744
where id in (5588416,5588377,5588349,5588365) and rosterid =1173464 ;

update ititestsessionhistory
set    rosterid=1231388,
       studentenrlrosterid=16262494,
       modifieddate =now(),
       modifieduser =174744
where id in (822771,822733,822699,822718) and rosterid= 1173464;


--MATH
update testsession 
set    rosterid =1231387,
       modifieddate =now(),
       modifieduser =174744
where id in (5588293,5588243,5588304,5588249,5588269,5588282) and rosterid =1173898 ;

update ititestsessionhistory
set    rosterid=1231387,
       studentenrlrosterid=16262492,
       modifieddate =now(),
       modifieduser =174744
where id in (822634,822581,822638,822590,822599,822617) and rosterid= 1173898;


update studentstests 
set    enrollmentid = 3318683,
       modifieddate =now(),
	   manualupdatereason='As for T302140'
where studentid =1421501 and enrollmentid =2987083 ;
commit;

