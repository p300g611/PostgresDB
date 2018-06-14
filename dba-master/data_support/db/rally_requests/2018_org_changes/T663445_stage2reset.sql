
--studentid:827524 inacitve stage1 and stage2

BEGIN;
--stage1 and stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #663445', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22485129,20828534) and studentid=827524 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22485129,20828534) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22485129,20828534) and studentid =827524 and activeflag =true ;





COMMIT;


