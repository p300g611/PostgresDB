BEGIN;

-SSID:1894707826 Reset test:all ELA--Stage 1 and Stage 2 - 4th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16859908,17067077);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16859908,17067077);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 796931 and studentstestsid in (16859908,17067077);

commit;