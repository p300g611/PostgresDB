BEGIN;

update enrollment 
set   exitwithdrawaldate='2016-08-17 05:00:00+00',
      modifieddate =now(),
	  modifieduser =174744
	  where id = 2821642 ;
	  
COMMIT;