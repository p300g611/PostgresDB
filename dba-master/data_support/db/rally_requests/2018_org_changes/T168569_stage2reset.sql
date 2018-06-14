
--SSID:9569639911   studentid:1166677 
BEGIN;
--active completed stage1 
update studentstests
set    activeflag =true,
       enrollmentid= 3412435,
       modifieddate=now(),
	  manualupdatereason ='as for ticket #168569', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21276615) and studentid=1166677 and activeflag =false;




update studentstestsections
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21276615) and activeflag =false  ;




--inactive unused stage1

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #168569', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22429975) and studentid=1166677 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22429975) and activeflag =true  ;

COMMIT;


