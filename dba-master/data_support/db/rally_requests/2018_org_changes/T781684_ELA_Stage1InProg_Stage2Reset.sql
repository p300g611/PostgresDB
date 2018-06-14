/*Ticket #781684
ELA reset Grade 10
3652525221
Stage 1 - In progress
Stage 2 - reset
*/

begin

--stage2


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #781684', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22323215 and studentid=674079 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22323215 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid = 22323215 and studentid =674079 and activeflag =true ;

--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #781684', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 20952826
and studentid=674079;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20952826;

COMMIT;

