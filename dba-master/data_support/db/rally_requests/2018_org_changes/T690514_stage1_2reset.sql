begin;

--SSID:4886628451  studentid:1168190 stage 1 and 2 ELA

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #636670', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22148176 and studentid=1168190 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22148176 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22148176 and studentid =1168190 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #636670', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20949443 and studentid=1168190 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20949443 ;


COMMIT;


