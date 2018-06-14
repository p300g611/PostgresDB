BEGIN;

UPDATE enrollment 
set    schoolentrydate='2013-05-13 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2914270 ;

UPDATE enrollment 
set    schoolentrydate='2012-08-15 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2863862 ;

UPDATE enrollment 
set    schoolentrydate='2013-08-15 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2864461 ;

UPDATE enrollment 
set    schoolentrydate='2016-08-23 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2864032 ;


UPDATE enrollment 
set    schoolentrydate='2010-08-17 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2856039 ;


UPDATE enrollment 
set    schoolentrydate='2012-08-17 05:00:00+00',
       modifieddate =now(),
	   modifieduser =174744
where  id =2856066 ;

COMMIT;