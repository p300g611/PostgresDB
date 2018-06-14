--deactivate the student test in grade 3. SSID:7399483566 studentstestsid:19704961
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='per ticket360894',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (19704961);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19704961);




update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1439394 and studentstestsid in (19704961) and activeflag is true;



commit;

