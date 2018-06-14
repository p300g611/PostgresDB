begin;

update aartuser 
set   displayname='Lisa Shear',
      modifieddate =now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
	  where id =45486 ;
	  
COMMIT;