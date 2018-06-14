BEGIN;

-SSID:3109004429 Reset test:all ELA-- Stage 2 - 7th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17067958;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17067958;

--reset stage1 to in process
update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =16057222;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16057222;


--inactive stage2 
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17388058;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17388058;

commit;