--SSID:8194136636 
begin;
--Math
update testsession 
set    rosterid =1229196,
       modifieddate =now(),
       modifieduser =174744
where id =5559533;

update ititestsessionhistory
set    rosterid=1229196,
       studentenrlrosterid=16248587,
       modifieddate =now(),
       modifieduser =174744
where id = 772680;



commit;