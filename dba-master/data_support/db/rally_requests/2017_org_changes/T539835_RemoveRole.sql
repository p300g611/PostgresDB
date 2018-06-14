BEGIN;


update userorganizationsgroups
set    activeflag =false,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 39701;


update userassessmentprogram
set    activeflag =false,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 222911;


COMMIT;