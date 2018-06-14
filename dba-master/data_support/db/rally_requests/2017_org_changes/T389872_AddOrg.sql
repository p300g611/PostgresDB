BEGIN;

update usersorganizations 
set    organizationid =3086,
       modifieddate = now(),
	   modifieduser =12
where id =15302;


COMMIT;