BEGIN;

update enrollment
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')	   
where id =2824811;

commit;
