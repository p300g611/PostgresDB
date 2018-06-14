BEGIN;

update usersorganizations
set organizationid = 82797,
    modifieddate = now(),
	modifieduser =12
where id = 81086;

COMMIT;