--deactivate the student test in grade 4. SSID:3198065089
begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (18960844,18960847,18960848,18960849,18960854,18960856,18960860,18960861,18960870,18960872,18960879,18960882,18960883,18960885);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18960844,18960847,18960848,18960849,18960854,18960856,18960860,18960861,18960870,18960872,18960879,18960882,18960883,18960885);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (18960844,18960847,18960848,18960849,18960854,18960856,18960860,18960861,18960870,18960872,18960879,18960882,18960883,18960885));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1026162 and studentstestsid in (18960844,18960847,18960848,18960849,18960854,18960856,18960860,18960861,18960870,18960872,18960879,18960882,18960883,18960885) and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1026162 and testsessionid in (select testsessionid from studentstests where id in (18960844,18960847,18960848,18960849,18960854,18960856,18960860,18960861,18960870,18960872,18960879,18960882,18960883,18960885));

commit;

