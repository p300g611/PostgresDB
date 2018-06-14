BEGIN;

-SSID:7235795891 Reset test:all ELA--Arts_Stage 1 and stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (15812095,16883605);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15812095,16883605);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 901345 and studentstestsid =16883605;

commit;