--SSID:2473468869
begin;
--ELA
update testsession 
set    rosterid =1174717,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =800278) and rosterid=1174718;

update ititestsessionhistory
set    rosterid=1174717,
       studentenrlrosterid=15723166,
       modifieddate =now(),
       modifieduser =174744
where studentid =800278 and rosterid=1174718;



commit;