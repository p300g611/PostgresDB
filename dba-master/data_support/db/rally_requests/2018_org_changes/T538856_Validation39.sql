--studentid:127082
begin;
update testsession 
set    rosterid =1254059,
       modifieddate =now(),
       modifieduser =174744
where id in (6020124) and rosterid =1253175 ;

commit;