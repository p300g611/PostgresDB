BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =66036;


update aartuser
set    username='orange.susan@usd443.org',
       email='orange.susan@usd443.org',
	   uniquecommonidentifier='9366484743',
	   modifieddate =now(),
	   modifieduser =12
where id =174181;


COMMIT;

