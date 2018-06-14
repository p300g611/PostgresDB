--deactivate the student test in grade 6. SSID:6097245912
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (18684202,18684214,18684219,18684220,18684225,18684230,18684236,18684242,18684251,18684254,18684259,18684266,18684269);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18684202,18684214,18684219,18684220,18684225,18684230,18684236,18684242,18684251,18684254,18684259,18684266,18684269);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (18684202,18684214,18684219,18684220,18684225,18684230,18684236,18684242,18684251,18684254,18684259,18684266,18684269));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 873828 and studentstestsid in (18684202,18684214,18684219,18684220,18684225,18684230,18684236,18684242,18684251,18684254,18684259,18684266,18684269) and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 873828 and testsessionid in (select testsessionid from studentstests where id in (18684202,18684214,18684219,18684220,18684225,18684230,18684236,18684242,18684251,18684254,18684259,18684266,18684269));

commit;

