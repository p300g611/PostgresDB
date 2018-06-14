
begin;
update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #768144'
where id in (19505233) and studentid=1436040 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19505233) and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1436040 and studentstestsid in (19505233) and activeflag is true;
                 
UPDATE testsession
 SET activeflag = false, 
     modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
     modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (19505233)) and activeflag is true;


commit;


