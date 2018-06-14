

BEGIN;
--SSID:1594282919  Test:Writing,Speaking

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15311890,15311887);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15311890,15311887);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 1396696 and studentstestsid in (15311890,15311887);


update scoringassignmentstudent
set    activeflag =false
where id in (178813,178815);

--SSID:6562322677 Test:Speaking

 update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15311720;



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid =15311720;



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 1396682 and studentstestsid=15311720;


update scoringassignmentstudent
set    activeflag =false
where id =178814;


COMMIT;

