/*Ticket #372604 
LAP Test Reset 
Please deactivate this same student's Stage 2 test for Math. With him getting Stage 1, he will need a new Stage 2 after completing Stage 1.
SSID: 4675367224
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #372604', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22724616 and studentid=1002500 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22724616 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22724616 and studentid =1002500 and activeflag =true ;


COMMIT;