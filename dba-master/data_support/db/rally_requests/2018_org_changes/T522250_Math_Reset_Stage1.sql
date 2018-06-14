/*Ticket #522250 
Math reset
Math
Grade 3
1051231264
stage 1 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #522250', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20625498 and studentid=1419062 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20625498 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =20625498 and studentid =1419062 and activeflag =true ;

COMMIT;
