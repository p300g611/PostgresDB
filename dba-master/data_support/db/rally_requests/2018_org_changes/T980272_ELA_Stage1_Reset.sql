/*Ticket #980272
Subject: 	Wants English Part 1 reactivated 
Reset English test Stage 1 for student 9667496066 KAP 
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket 980272', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21933193 and studentid=183161 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21933193 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =21933193 and studentid =183161 and activeflag =true ;

COMMIT;

