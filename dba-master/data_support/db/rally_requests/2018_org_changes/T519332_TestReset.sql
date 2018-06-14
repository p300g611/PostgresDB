--reset test.SSID:9173810122 testname:EE.3.NBT.3
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id =18993941;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =18993941;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id =18993941);


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1417809 and studentstestsid =18993941 and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1417809 and testsessionid in (select testsessionid from studentstests where id =18993941);

commit;

