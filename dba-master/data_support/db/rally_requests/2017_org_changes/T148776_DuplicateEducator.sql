
BEGIN;
update aartuser
 set  uniquecommonidentifier =uniquecommonidentifier||'_old',
	  modifieddate = now(),
	  modifieduser = 12
  where id= 68374;
  
  
update aartuser
 set uniquecommonidentifier ='2353866743',
	modifieddate = now(),
	modifieduser = 12
  where id = 14295;
  
  

  
update  usersorganizations
 set  activeflag = false,
      modifieddate = now(),
	  modifieduser = 12
  where id =69379 and activeflag is true;
  
  
COMMIT;
  
  

  
  
  
 