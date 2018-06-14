begin;

--SSID:4367831523 
update scoringassignmentstudent
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studentstestsid in (19604383,19604391) and studentid =1442331 and  activeflag is true;
	   
update studentstestscore
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studenttestid in (19604383,19604391) and  activeflag is true;
	   

--SSID:7139737878 
update scoringassignmentstudent
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studentstestsid in (19689695,19689696) and studentid =1451922 and  activeflag is true;
	   
update studentstestscore
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studenttestid in (19689695,19689696) and  activeflag is true;
	   
commit;
