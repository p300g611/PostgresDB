begin;

--SSID:9435449425  studentid:622051 stage 1 and 2 MATH

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #768807 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21990498 and studentid=622051 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21990498 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =21990498 and studentid =622051 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #768807', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20793986 and studentid=622051 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20793986 ;


COMMIT;


