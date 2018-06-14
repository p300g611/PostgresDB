BEGIN;

update usersorganizations
set organizationid = 82845,
    activeflag =true,
    modifieddate= now(),
	modifieduser =12
where id  in (70125,166200,166202,166203);

COMMIT;




