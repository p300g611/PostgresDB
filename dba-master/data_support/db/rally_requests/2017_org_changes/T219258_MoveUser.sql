BEGIN;

update aartuser
  set  username = username||'_old',
       email = email||'_old',
	   activeflag = false,
	   modifieddate = now(),
	   modifieduser =12
	 where id = 72773;
	 
update usersorganizations
   set organizationid =18176,
       activeflag = true,
	   modifieddate = now(),
	   modifieduser =12   
	where id =74233;
     
COMMIT;