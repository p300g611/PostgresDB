--Ticket #176542
begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #176542', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21063981,22109645,20769937,22063759) and studentid=1132473 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21063981,22109645,20769937,22063759) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21063981,22109645,20769937,22063759) and studentid =1132473 and activeflag =true ;

COMMIT;


