/*Ticket #967477 
ELA reset grade 4
1662219547
Stage 2 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #967477', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22270998 and studentid=1072626 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22270998 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22270998 and studentid =1072626 and activeflag =true ;


COMMIT;