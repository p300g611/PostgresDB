/*Ticket #941863
ELA grade 7
4912688258
Stage 1 - In progress
Stage 2 - reset
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #941863', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22025778 and studentid=625633 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22025778 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22025778 and studentid =625633 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #941863', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 21855903
and studentid=625633;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21855903 ;

COMMIT;

