/*Ticket #405063
has been assigned to you by Connie B. 
Subject: 	reset MATH test 
Grade 7
4912688258
Stage 1 in progress
Stage 2 reset
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #405063', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22038383 and studentid=625633  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22038383 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22038383 and studentid =625633 and activeflag =true ;


--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #405063', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20789848
and studentid=625633 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20789848 ;


COMMIT;
