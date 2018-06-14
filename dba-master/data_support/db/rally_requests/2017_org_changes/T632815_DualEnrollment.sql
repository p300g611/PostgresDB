

BEGIN;
update enrollment 
set    activeflag=false,
       modifieddate=now(),
	   modifieduser =174744	   
where id =2755080;



update studentstests
set    enrollmentid=2419119,
       modifieddate=now(),
	   modifieduser =174744	   
where id in (15529942,15529943,15529962) and enrollmentid =2755080;



update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16561315,16564483);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16561315,16564483);


COMMIT;



