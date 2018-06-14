/*Ticket #265416
Math reset
Grade 4
5814149132
Stage 1 - In progress
STage 2 - reset
*/


begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #265416', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22688279 and studentid=1228611  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22688279 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  = 22688279 and studentid =1228611 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #265416', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=20727456
and studentid=1228611;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20727456;

COMMIT;

