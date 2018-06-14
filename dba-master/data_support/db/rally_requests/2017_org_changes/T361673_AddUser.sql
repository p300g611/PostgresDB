BEGIN;

UPDATE aartuser 
set  email =email||'_old',
     username = username||'_old',
	 modifieddate = now(),
	 modifieduser =12
  where id = 20805;
  
 COMMIT;

 

