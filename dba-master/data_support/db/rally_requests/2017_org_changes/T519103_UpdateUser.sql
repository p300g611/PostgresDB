BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =57868;



update aartuser
set    username='tjensen@usd259.net',
	   modifieddate =now(),
	   modifieduser =12
where id =123948;


COMMIT;


