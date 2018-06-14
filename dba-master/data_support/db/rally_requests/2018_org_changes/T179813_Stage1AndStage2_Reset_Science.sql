/*Ticket #179813
Reset Science - Grade 10
Student ID # 1404819223
Reset - Stage 1
Reset - Stage 2
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #179813', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20467883,20467888) and studentid=587492 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20467883,20467888) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (20467883,20467888) and studentid =587492 and activeflag =true ;

COMMIT;
