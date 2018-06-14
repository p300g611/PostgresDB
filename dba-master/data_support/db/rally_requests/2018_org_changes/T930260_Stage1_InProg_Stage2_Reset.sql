/* Ticket #930260
Reset 6163448367
Math Grade 3
Stage 1 - In Progress
Stage 2 - Reset
Thanks  Connie
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #930260', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21790380 and studentid=1232038  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21790380 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21790380 and studentid =1232038 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #930260', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20840858
and studentid=1232038 ;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20840858 ;

COMMIT;
