--ssid:473962765 reset test:YEELA3.5S

BEGIN;
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16703314;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16703314;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id =16703314);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1354341 and studentstestsid =16703314;

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id =16703314);

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id =16703314)) and studentid= 1354341; 

COMMIT;