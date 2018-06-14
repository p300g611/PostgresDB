/* Ticket #347573
Set stage 1 to in progress and Inactivate stage 2
---------------
studentid | 621470
testid | 111957
stid | 21085370
test | English Language Arts Grade 7: Session 1
rosterid |
st_status | Complete
af | t
enrollmentid | 3300900
e_active | t
scoringassignmentid |
id | 5878497
---------------
studentid | 621470
testid | 111989
stid | 21743297
test | English Language Arts Grade 7: Session 2
rosterid |
st_status | Complete
af | t
enrollmentid | 3300900
e_active | t
scoringassignmentid |
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #347573', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21743297 and studentid=621470  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21743297 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21743297 and studentid =621470  and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #347573', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21085370
and studentid=621470 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21085370 ;


COMMIT;
