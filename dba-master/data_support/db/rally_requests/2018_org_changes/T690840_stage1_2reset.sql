/*Inactivate studentstests id (22926867, 22926868)
Activate studentstests id (22231031, 22625887, 21005188, 20707433)
*/

BEGIN;
--deactivate 
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #690840', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22926867,22926868) and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22926867,22926868) and activeflag =true;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid in (22926867,22926868) and activeflag =true;

--activate 
update studentstests
set    activeflag =true, 
       modifieddate=now(),
	   status=86,
	  manualupdatereason ='as for ticket #690840', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20707433,21005188,22231031) and activeflag =false;

update studentstests
set    activeflag =true, 
       modifieddate=now(),
	   status=84,
	  manualupdatereason ='as for ticket #690840', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22625887) and activeflag =false;

COMMIT;
