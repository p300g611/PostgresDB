--deactivate the student test in grade 5. SSID:8631194417
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='Ticket #529784',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (19342057,19342060,19342061,19342062,19342063,19342065,19342066,19342069,19342071,19342076,19342077,19342079,19342082);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19342057,19342060,19342061,19342062,19342063,19342065,19342066,19342069,19342071,19342076,19342077,19342079,19342082);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (19342057,19342060,19342061,19342062,19342063,19342065,19342066,19342069,19342071,19342076,19342077,19342079,19342082));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1339991 and studentstestsid in (19342057,19342060,19342061,19342062,19342063,19342065,19342066,19342069,19342071,19342076,19342077,19342079,19342082) and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1339991 and testsessionid in (select testsessionid from studentstests where id in (19342057,19342060,19342061,19342062,19342063,19342065,19342066,19342069,19342071,19342076,19342077,19342079,19342082));

commit;

