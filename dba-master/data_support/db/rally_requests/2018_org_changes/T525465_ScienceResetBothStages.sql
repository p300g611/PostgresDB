/*Ticket #525465
Reset Science Test Grade 5
6192367876
Stage 1 reset
Stage 2 reset
Thanks Connie
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #525465', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20464067,20464073) and studentid=1197309 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20464067,20464073) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20464067,20464073) and studentid =1197309 and activeflag =true ;

COMMIT;
