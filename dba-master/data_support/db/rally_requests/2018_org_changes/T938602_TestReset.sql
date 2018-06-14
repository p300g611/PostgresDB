--reset test.SSID:9173810122 testname:ITI: ELA.EE.RI.9-10.3 PP
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id =19346412;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =19346412;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id =19346412);


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 877799 and studentstestsid =19346412 and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 877799 and testsessionid in (select testsessionid from studentstests where id =19346412);

commit;

