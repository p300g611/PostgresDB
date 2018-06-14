--Ticket #399549
begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #850734', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20929580,22495729) and studentid=721296 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20929580,22495729) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20929580,22495729) and studentid =721296 and activeflag =true ;

COMMIT;


