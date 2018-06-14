BEGIN;

UPDATE enrollment 
set    schoolentrydate='2016-08-15 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2767531 ;


commit;