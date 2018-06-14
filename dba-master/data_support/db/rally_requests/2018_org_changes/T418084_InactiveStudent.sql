/*Ticket #418084  

ssid: 9381325707 Inactivate enrollment, student, and students test for studentid = 1167636

*/

begin
update  student
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =1167636 and activeflag =true  ;

update  enrollment
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =3206244 and activeflag =true  ;



update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #418084', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id IN (19944569,19944678,20743460,21049948) and studentid=1167636 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid IN (19944569,19944678,20743460,21049948)  and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  IN (19944569,19944678,20743460,21049948)  and studentid =1167636 and activeflag =true ;


COMMIT;