BEGIN;
--EXIT STUDENT: exitwithdrawaldate:NULL,exitwithdrawaltype:0 

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype=2,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2493786;


UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype=21,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2493394;


UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype=3,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2493567,
2493612,
2493889,
2588621,
2488940,
2494149,
2493293,
2493580
);

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-6 06:00:00+00',
	   exitwithdrawaltype=3,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2489255;


UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype=2,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2539303;

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype=3,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2493660,
2493292,
2493419,
2493098,
2563720,
2493322,
2493585
);

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-16 06:00:00+00',
	   exitwithdrawaltype=2,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2493141;


UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-16 06:00:00+00',
	   exitwithdrawaltype=3,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2493489,
2493081,
2566527,
2588628,
2493124,
2493487,
2493417
);

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-9 06:00:00+00',
	   exitwithdrawaltype=3,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2488999,
2493340,
2495081,
2493648,
2495101,
2493526,
2493555
);

COMMIT;
