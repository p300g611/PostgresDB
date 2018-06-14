/* ticket 661909
Test reset
Student ID: 4133167503
Test name: ELA.EE.CW.4.PP
*/

begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
	  manualupdatereason='Ticket #661909'
where id =18975471;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =18975471;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id =18975471);


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1323849 and studentstestsid =18975471 and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1323849 and testsessionid in (select testsessionid from studentstests where id =18975471);

commit;

