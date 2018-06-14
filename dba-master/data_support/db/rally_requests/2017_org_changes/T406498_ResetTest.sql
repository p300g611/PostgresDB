BEGIN;

-SSID:8019076786,stuid:357397 Reset test: ELA-- Stage 2 - 7th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17115271;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17115271;

COMMIT;
