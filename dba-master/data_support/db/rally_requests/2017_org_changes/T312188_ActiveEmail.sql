BEGIN;

update aartuser
 set username = username||'_old',
     email=email||'_old',
	 activeflag = false,
	 modifieddate=now(),
	 modifieduser = 12
  where id = 163979 and activeflag is true;
  
  
COMMIT;