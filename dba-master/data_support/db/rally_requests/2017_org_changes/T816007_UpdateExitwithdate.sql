BEGIN;

update enrollment 
set    exitwithdrawaldate='2017-01-26 06:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where id =2772013;


commit;