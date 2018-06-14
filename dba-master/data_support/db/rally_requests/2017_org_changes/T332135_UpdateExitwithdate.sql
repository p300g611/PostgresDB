BEGIN;

update enrollment 
set    exitwithdrawaldate='2016-12-21 06:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where id =2753155 ;


commit;