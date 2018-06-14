BEGIN;

update usersorganizations
   set organizationid = 82632,
       activeflag = true,
   	   modifieddate = now(),
	   modifieduser =12   
	where id =80733;
	
COMMIT;