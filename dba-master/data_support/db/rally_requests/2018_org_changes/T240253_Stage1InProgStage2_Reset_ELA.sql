/*Ticket #240253 
Reset as follows:
Grade 6 
ELA
8286063082
Stage 1 - In progress
Stage 2 - reset
Thanks Connie
*/
begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #240253 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21631651 and studentid=271335 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21631651 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21631651 and studentid =271335 and activeflag =true ;



--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #240253', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=21044871
and studentid=271335;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21044871 ;


COMMIT;