BEGIN;
update aartuser 
   set uniquecommonidentifier =uniquecommonidentifier||'_old',
       activeflag = false,
	   modifieddate = now(),
	   modifieduser =12	   
  where id = 123341 and activeflag is true;
  
  
update usersorganizations 
  set activeflag = false,
      modifieddate = now(),
	  modifieduser =12
	where id = 132557 and activeflag is true;

	
COMMIT;