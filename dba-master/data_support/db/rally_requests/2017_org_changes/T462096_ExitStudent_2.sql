--SSID:8641421289,8350169192,4586655607,8081438599,4624451155,1676562125,5578581137,8474106567
--exitwithdrawaldate:NULL, exitwithdrawaltype:0;



BEGIN;

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype='2',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2601870;
       
UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2494340;

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2494384;

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-16 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2494541,2505307,2494675);

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-9 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2494678,2494825);


COMMIT;