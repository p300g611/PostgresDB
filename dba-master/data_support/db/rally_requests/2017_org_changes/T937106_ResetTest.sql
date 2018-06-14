BEGIN;

--STUDENTID:1391765   reset test: testsessionid = 4022844, 4022842
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15166858,15166849);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15166858,15166849);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestsid in (15166858,15166849) and studentid=1391765 ;


update scoringassignmentstudent
set    activeflag =false
where studentstestsid in  (15166858,15166849) and studentid=1391765 ;


COMMIT;