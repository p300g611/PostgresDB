BEGIN;

UPDATE enrollment
set    schoolentrydate='2016-07-26 06:00:00+00',
      modifieddate=now(),
	  modifieduser=174744
where id =2892561;



UPDATE enrollment
set    schoolentrydate='2010-07-06 06:00:00+00',
      modifieddate=now(),
	  modifieduser=174744
where id =2893260;


COMMIT;