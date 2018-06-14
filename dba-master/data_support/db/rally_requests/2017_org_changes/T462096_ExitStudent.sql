BEGIN;

--exit ssid: 1272388522,6633154291,8747471883
UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-13 06:00:00+00',
	   exitwithdrawaltype='21',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2564428;

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2493015;


UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype='2',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2493038;


update enrollmentsrosters
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where enrollmentid in (2564428,2493015,2493038);

--exit ssid:7952867415,9245393976,9935496279,7270225702,4782394764
UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-11-9 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2495033,2494955,2563732);

UPDATE enrollment 
set    activeflag =false,
       exitwithdrawaldate ='2016-12-2 06:00:00+00',
	   exitwithdrawaltype='3',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id in (2495056,2566722);

update enrollmentsrosters
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where enrollmentid in (2495033,2494955,2563732,2495056,2566722);


COMMIT;



