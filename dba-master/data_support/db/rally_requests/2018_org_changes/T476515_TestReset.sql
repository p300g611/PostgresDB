
begin;
update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #476515'
where id in (18668863,18668859) and studentid=703983 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18668863,18668859) and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 703983 and studentstestsid in (18668863,18668859) and activeflag is true;
                 
UPDATE testsession
 SET activeflag = false, 
     modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
     modifieddate = now()
     WHERE id IN (5570195,5570191) and activeflag is true;

update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 703983 and id in (771893,771954);
     
commit;


