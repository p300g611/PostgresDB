BEGIN;

UPDATE enrollment 
set     schoolentrydate ='2012-08-15 05:00:00+00',
      modifieddate =now(),
	   modifieduser =174744
	   where id = 2927683 ;
	   
commit;