/*Ticket #713129
ELA Grade 4
4379763552
Stage 1 - In progress
Stage 2 - reset 
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #713129', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22386133 and studentid=1184218  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22386133 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  = 22386133 and studentid =1184218 and activeflag =true ;

--stage1

update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #713129', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=21098020
and studentid=1184218;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21098020;

COMMIT;

