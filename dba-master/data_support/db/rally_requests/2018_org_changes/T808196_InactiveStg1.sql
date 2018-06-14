/*Ticket #808196 

SSID: 3185960912
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #808196', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =23014310 and studentid=167471 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =23014310 and activeflag =true  ;




COMMIT;