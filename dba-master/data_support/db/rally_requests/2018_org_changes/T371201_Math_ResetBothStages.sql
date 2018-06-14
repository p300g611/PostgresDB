/*Ticket #371201
RE: Test Re-Set @ 8533 
Math reset Grade 8
4535937532
stage 1 - reset
stage 2 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #371201', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20630909,22695301) and studentid=318156 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20630909,22695301) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20630909,22695301) and studentid =318156 and activeflag =true ;

COMMIT;



