/*Ticket #719419
reset ELA Grade 10
6759289765
Stage 1 - In progress
Stage 2 - reset
*/


begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #719419', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22323209 and studentid=672447 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22323209 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22323209 and studentid =672447 and activeflag =true ;

--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #719419', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 20952696
and studentid=672447;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20952696;

COMMIT;

