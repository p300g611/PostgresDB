/*Ticket #224124
Science reset
Science
grade 11
3434278257
Reset stage 1
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #224124', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20309620 and studentid=900122 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20309620 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =20309620 and studentid =900122 and activeflag =true ;

COMMIT;
