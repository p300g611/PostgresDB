BEGIN;

update enrollment 
set    exitwithdrawaldate='2014-08-12 05:00:00+00' ,
       schoolentrydate='2014-08-12 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where id =2845384  ;


commit;