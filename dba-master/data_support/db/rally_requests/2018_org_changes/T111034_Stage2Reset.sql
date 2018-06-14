--stage2
--SSID:8717171857 .reset stage1 in progress and stage2 is unused for ELA

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #111034', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21458327 and studentid=591036 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21458327 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21458327 and studentid =591036 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #111034', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21040385 and studentid=591036;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21040385 ;


COMMIT;