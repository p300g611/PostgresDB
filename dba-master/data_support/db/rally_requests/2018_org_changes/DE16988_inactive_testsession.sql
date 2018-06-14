
begin;
update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #DE16988'
where id in (18647609,18647379) and studentid=853230 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18647609,18647379) and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 853230 and studentstestsid in (18647609,18647379) and activeflag is true;
                 
UPDATE testsession
 SET activeflag = false, 
     modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
     modifieddate = now()
     WHERE id IN (5556600,5556428) and activeflag is true;

update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 853230 and testsessionid in (5556600,5556428) and activeflag is true;
     
commit;


