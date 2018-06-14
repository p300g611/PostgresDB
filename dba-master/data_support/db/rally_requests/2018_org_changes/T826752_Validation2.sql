--deactivate the student test in grade 6. stuentid:1287480
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='for ticket#826752',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21259771,21260663);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21259771,21260663);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (21259771,21260663));


update studenttrackerband
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where id in (21259771,21260663));
commit;

