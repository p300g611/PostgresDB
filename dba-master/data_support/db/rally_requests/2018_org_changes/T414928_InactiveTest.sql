--deactivate the student test in grade 8. SSID:6938843376
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (18988881,18988882,18988883,18988884,18988886,18988887,18988888,19028171,19028174,19028176,19028178,19028182,19028185);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18988881,18988882,18988883,18988884,18988886,18988887,18988888,19028171,19028174,19028176,19028178,19028182,19028185);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (18988881,18988882,18988883,18988884,18988886,18988887,18988888,19028171,19028174,19028176,19028178,19028182,19028185));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1205852 and studentstestsid in (18988881,18988882,18988883,18988884,18988886,18988887,18988888,19028171,19028174,19028176,19028178,19028182,19028185) and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1205852 and testsessionid in (select testsessionid from studentstests where id in (18988881,18988882,18988883,18988884,18988886,18988887,18988888,19028171,19028174,19028176,19028178,19028182,19028185));

commit;

