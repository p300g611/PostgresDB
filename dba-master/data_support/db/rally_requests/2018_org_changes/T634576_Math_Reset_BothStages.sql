/* Ticket #634576 
Math test Reset Grade 3
5751716647
Stage 1 - reset
Stage 2 - reset
*/


begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #634576 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20786424,22688582) and studentid=1257292 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20786424,22688582) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20786424,22688582) and studentid =1257292 and activeflag =true ;

COMMIT;
