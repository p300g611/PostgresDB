Begin;

update aartuser
  set uniquecommonidentifier =uniquecommonidentifier||'_old',
      username =username||'_old',
	  email =email||'_old',
      activeflag = false,
	  modifieddate =now (),
	  modifieduser =12
	where id = 58795;
	
	
	
update aartuser
 set  uniquecommonidentifier ='8712329924',
      modifieddate = now(),
      modifieduser = 12
  where id  =162971;

  
  
COMMIT;
