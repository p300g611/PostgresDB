/* Ticket #795400
Math reset Grade 3
3510480503
Stage 1 - reset
Stage 2 - reset
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #795400', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20787340,22691076) and studentid=874710 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20787340,22691076) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20787340,22691076) and studentid =874710 and activeflag =true ;

COMMIT;



