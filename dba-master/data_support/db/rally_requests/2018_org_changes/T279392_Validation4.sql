--deactivate the student test in grade 8. stuentid:1237565 , studentstestsid: 20886504, 20860876
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='for ticket#279392',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20860876,20886504);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20860876,20886504);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (20860876,20886504));

update studentsresponses 
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsid in (20860876,20886504) and studentid=1237565;


update studenttrackerband
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where id in (20860876,20886504));

  
commit;

