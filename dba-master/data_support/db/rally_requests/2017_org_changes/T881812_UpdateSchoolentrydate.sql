BEGIN;

--Studentid:271894

update enrollment 
set    schoolentrydate='2016-06-13 05:00:00+00',
       modifieddate=now(),
	   modifieduser=174744
where id = 2488148;

commit;