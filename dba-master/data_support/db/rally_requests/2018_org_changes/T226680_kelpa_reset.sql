begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #226680'
where id = 19663076 and studentid=530667 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 19663076 and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 530667 and studentstestsid = 19663076 and activeflag is true;





commit;
