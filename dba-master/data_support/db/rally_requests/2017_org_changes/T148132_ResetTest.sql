BEGIN;

-SSID:2884134018 Reset test:all ELA--Stage 1 and Stage 2 - 5th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16494696,16935805);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16494696,16935805);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 734912 and studentstestsid in (16494696,16935805);

commit;