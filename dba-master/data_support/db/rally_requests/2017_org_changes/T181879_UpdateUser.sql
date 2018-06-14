BEGIN;

UPDATE aartuser 
set  username = username||'_old',
     email=email||'_old',
	 uniquecommonidentifier=uniquecommonidentifier||'_old',
	 activeflag =false,
	 modifieddate =now(),
	 modifieduser =12
where id = 35534;



UPDATE aartuser
set  uniquecommonidentifier='6486557435',
 	 modifieddate =now(),
	 modifieduser =12    
where id = 167315;

COMMIT;
	