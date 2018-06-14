BEGIN;

update usersorganizations
    set activeflag = false,
	    modifieddate = now(),
		modifieduser =12
	where id in (83896,94019);
	
	
update usersorganizations
    set organizationid =38806,
	    modifieddate = now(),
		modifieduser =12
	where id = 94020;
	
COMMIT;