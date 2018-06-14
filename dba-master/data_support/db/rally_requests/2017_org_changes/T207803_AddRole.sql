BEGIN;

update usersorganizations
set activeflag =true,
    organizationid = 84598,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  in (202178,202179);


commit;