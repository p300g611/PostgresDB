BEGIN;

--SSID:5675356878,4747928812,4054091911 reset test:  K-ELPA Grade 8 Reading


update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15090377,15090843,15090485);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15090377,15090843,15090485);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 484858 and studentstestsid =15090377;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 39815 and studentstestsid =15090843;



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 1121275 and studentstestsid =15090485;


COMMIT;