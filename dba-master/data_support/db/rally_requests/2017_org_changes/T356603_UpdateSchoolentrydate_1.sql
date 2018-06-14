BEGIN;

UPDATE enrollment 
set    exitwithdrawaldate='2017-01-30 06:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2517094 ;


commit;