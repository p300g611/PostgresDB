BEGIN;

update usersorganizations
set organizationid = 15789,
    activeflag =true,
    modifieddate= now(),
	modifieduser =12
where id  = 78622;

update usersorganizations
set organizationid = 59355,
    activeflag=true,
    modifieddate= now(),
	modifieduser =12
where id  in (46077,78659);

COMMIT;