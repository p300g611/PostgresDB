BEGIN;
--SSID:9352622561 Test:Listening,Speaking

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15274839,15274841);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15274839,15274841);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 1009294 and studentstestsid in (15274839,15274841);

--scoringassignmentstudent

update scoringassignmentstudent
set    activeflag =false
where id =80362;

COMMIT;