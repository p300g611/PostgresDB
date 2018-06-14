/*Ticket #698761 
Reset request:
ELA
Grade 4
7252116794
Stage 1 - In progress
Stage 2 - Reset
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #698761', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22153366 and studentid=1101428 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22153366 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22153366 and studentid =1101428 and activeflag =true ;


--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #698761', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 21656098
and studentid=1101428;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21656098 ;

COMMIT;