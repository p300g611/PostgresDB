--SSID:298456512 
begin;
--ELA
update testsession 
set    rosterid =1212150,
       modifieddate =now(),
       modifieduser =174744
where id in (5727338,5696685,5696690,5696686,5696689,5696687) and rosterid =1199314 ;

update ititestsessionhistory
set    rosterid=1212150,
       studentenrlrosterid=16401620,
       modifieddate =now(),
       modifieduser =174744
where id in (950427,920395,920403,920407,920399,920409) and rosterid= 1199314;



commit;

