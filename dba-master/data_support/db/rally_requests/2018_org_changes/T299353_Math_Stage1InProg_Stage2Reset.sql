/*Ticket #299353
Math reset Grade 7
5402291071
Stage 1 in progress
Stage 2 reset
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #299353', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22273600 and studentid=623089  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22273600 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22273600 and studentid =623089 and activeflag =true ;


--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #299353', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20789448
and studentid=623089 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20789448;


COMMIT;
