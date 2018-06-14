/*Ticket #240226 
Reset ELA Grade 4
3619737223
Stage 1 - In Progress
Stage 2 - reset
*/

begin

--stage 2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #240226', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22025778 and studentid=831894 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22025778 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22025778 and studentid =831894 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #240226', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 21855903
and studentid=831894;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21855903 ;

COMMIT;