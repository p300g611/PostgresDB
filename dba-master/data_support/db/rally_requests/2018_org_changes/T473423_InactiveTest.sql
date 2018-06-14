--deactivate the student test in grade 3. SSID:4810715825 studentstestsid:1006438
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='per ticket473423',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (19575694,19575703,19575713,19575717);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19575694,19575703,19575713,19575717);




update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1006438 and studentstestsid in (19575694,19575703,19575713,19575717) and activeflag is true;



commit;

