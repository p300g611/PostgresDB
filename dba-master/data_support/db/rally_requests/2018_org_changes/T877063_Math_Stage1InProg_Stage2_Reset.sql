/*Ticket #877063
Math reset Grade 4
1365346366
Stage 1 - in progress
Stage 2 - reset 
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #877063', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22393168 and studentid=1085852  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22393168 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22393168 and studentid =1085852 and activeflag =true ;


--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #877063', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20727913
and studentid=1085852 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20727913;


COMMIT;
