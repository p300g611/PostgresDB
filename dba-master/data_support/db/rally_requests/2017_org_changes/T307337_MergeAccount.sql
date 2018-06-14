BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =71270;

COMMIT;