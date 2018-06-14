--deactivate the student test i. stuentid:1469664,studentstestsid: 21260170
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='for ticket#646822',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21260170);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21260170);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (21260170));

update studenttrackerband
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where id in (21260170));
commit;

