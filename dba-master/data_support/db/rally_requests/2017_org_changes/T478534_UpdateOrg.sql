
BEGIN;

update usersorganizations
     set organizationid= 2629,
	     modifieddate = now(),
		 modifieduser =12
	where id = 19552;
	
COMMIT;
	     