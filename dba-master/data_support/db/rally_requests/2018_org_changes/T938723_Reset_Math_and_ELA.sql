-- Ticket 938723

begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #938723'
where id in (21180287);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21180287);

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1408106 and studentstestsid in (21180287) and activeflag is true;

update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where  
id in (21180287));

update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1408106 and testsessionid in (select testsessionid from studentstests where id 
in (21180287));

commit;


begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #938723'
where id in (20893877);

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20893877);

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1354290 and studentstestsid in (20893877) and activeflag is true;

update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where  
id in (20893877));

update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid =1354290 and testsessionid in (select testsessionid from studentstests where id 
in (20893877));

commit;

