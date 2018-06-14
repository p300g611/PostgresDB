--inactive ssid:2231284251,subject:ss.Please clear the scoring assignment value and set the scoring status to NULL.

begin;

update studentstestscore
set   activeflag =false,
      modifieddate=now(),
	  modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu')
	  where id = 2002412;
	  
	  
update 	scoringassignmentstudent
set    activeflag =false,
      modifieddate=now(),
	  modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu')
	  where id=586576;
	  


commit;
