--ssid:5793060472 subject:Math

BEGIN;
--stage1
update studentstests
set    status=84, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #856550 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 20714477 and studentid=1152921 and activeflag =true;


update studentstestsections
set    statusid=125,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20714477 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =20714477 and studentid =1152921 and activeflag =true ;

commit;