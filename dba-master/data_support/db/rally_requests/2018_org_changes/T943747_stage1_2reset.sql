begin;

--SSID:6492559533  studentid:896404 stage 1 and 2 ELA

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #943747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22016254 and studentid=896404 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22016254 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22016254 and studentid =896404 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #943747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21393831 and studentid=896404 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21393831 ;


COMMIT;


