/*Ticket #368430  
ELA reset grade 4
1662219547
Stage 2 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #368430', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id IN (20963906,22702854) and studentid=1425242 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid IN (20963906,22702854)  and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  IN (20963906,22702854)  and studentid =1425242 and activeflag =true ;


COMMIT;