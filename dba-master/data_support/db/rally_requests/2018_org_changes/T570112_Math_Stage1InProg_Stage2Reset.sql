/*Ticket #570112
Math reset Grade 3
4562984848
Stage 1 In progress
Stage 2 reset 
*/

begin
--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #570112', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22128555
 and studentid=1037156 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22128555
 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22128555
 and studentid =1037156 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #570112', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20757149
and studentid=1037156;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20757149;

COMMIT;
