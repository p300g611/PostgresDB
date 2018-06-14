/*Ticket #358101 
Reset Grade 3 ELA
2471001009
Stage 2 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #358101', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22245637 and studentid=875321 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22245637 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22245637 and studentid =875321 and activeflag =true ;

COMMIT;