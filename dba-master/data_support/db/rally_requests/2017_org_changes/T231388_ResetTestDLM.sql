BEGIN;
--ssid:5013965971  reset test:ELA--YE M 7.1 DP
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16598344;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16598344;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id =16598344);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1264556 and studentstestsid =16598344;

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id =16598344);

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id =16598344)) and studentid= 1264556;
commit;