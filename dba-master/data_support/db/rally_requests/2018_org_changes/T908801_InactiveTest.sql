--deactivate the student test in grade 3. SSID:2387765931 studentstestsid:19701501
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='per ticket908801',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (19701501);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19701501);




update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1338773 and studentstestsid in (19701501) and activeflag is true;



commit;

