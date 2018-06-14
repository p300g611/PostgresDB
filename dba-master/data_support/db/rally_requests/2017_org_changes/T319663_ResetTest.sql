BEGIN;

--SSID:1608548368  reset all four demains of K-elpa 


update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15516755,15516752,15516754,15516753);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15516755,15516752,15516754,15516753);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 184747 and studentstestsid in (15516755,15516752,15516754,15516753);


update scoringassignmentstudent
set    activeflag =false
where id in (239080,239084);

--SSID:4227716977  reset all four demains of K-elpa 

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (15516763,15516761,15516760,15516762);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid in (15516763,15516761,15516760,15516762);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 184796 and activeflag is true;


update scoringassignmentstudent
set    activeflag =false
where id in (239081,239085);



COMMIT;