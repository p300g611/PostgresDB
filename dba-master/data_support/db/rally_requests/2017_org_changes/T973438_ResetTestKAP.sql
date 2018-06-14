BEGIN;

-SSID:7969703054 Reset test:all ELA--Stage 1 and Stage 2 - 8th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16555032,16971524);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16555032,16971524);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 796931 and studentstestsid in (16555032,16971524);

commit;