/*Ticket #980272  
Wants English Part 1 reactivated 
reactivate stage 1 and set to in progress. Inactivate stage 2 of ela.
9667496066
*/

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #980272', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21990034 and studentid=183161  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21990034 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21990034 and studentid =183161  and activeflag =true ;

--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #980272', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21933193
and studentid=183161 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21933193 ;

--
update studentstests
set    activeflag =true, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #980272', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21933193  and studentid=183161  and activeflag =false;


update studentstestsections
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21933193  and activeflag =false  ;


update studentsresponses
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21933193  and studentid =183161  and activeflag =false ;


COMMIT;