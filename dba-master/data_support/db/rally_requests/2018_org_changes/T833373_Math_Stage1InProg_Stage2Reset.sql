/*Ticket #833373
Math Grade 7
4357028698
Stage 1 - in progress
stage 2 - Reset
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #833373', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22568333
 and studentid=698829 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22568333
 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22568333
 and studentid =698829 and activeflag =true ;


--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #833373', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21354304
and studentid=698829;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21354304;


COMMIT;
