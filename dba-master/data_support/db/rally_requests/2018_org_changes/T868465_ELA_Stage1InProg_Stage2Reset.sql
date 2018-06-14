/*Ticket #868465
Ela Reset Grade 10
9733462292
Stage 1 - In progress
Stage 2 - reset
*/

begin

--stage2


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #868465', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22461504 and studentid=147180  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22461504 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  = 22461504 and studentid= 147180 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #868465', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=20977895
and studentid=147180;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20977895;

COMMIT;


