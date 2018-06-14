begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #864305'
where id = 19541437 and studentid=1439229 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 19541437 and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1439229 and studentstestsid = 19541437 and activeflag is true;





commit;
