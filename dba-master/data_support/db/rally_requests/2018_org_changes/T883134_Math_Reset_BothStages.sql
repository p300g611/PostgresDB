/* Ticket #883134
Math test Reset Grade 7
5103306409
Stage 1 - reset
Stage 2 - reset
*/


begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #883134 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20667201,22720790) and studentid=1328010 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20667201,22720790) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20667201,22720790) and studentid =1328010 and activeflag =true ;

COMMIT;
