/*Ticket #372604
reset stage 1 math for the following student. 
SSID: 4675367224
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #372604', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20618321 and studentid=1002500 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20618321 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =20618321 and studentid =1002500 and activeflag =true ;

COMMIT;



