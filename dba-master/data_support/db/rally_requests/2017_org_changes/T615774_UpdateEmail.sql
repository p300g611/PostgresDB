BEGIN;
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =51503;


update aartuser
set    username='lldouglas@usd288.org',
       email='lldouglas@usd288.org',
	   uniquecommonidentifier='lldouglas@usd288.org',
	   modifieddate =now(),
	   modifieduser =12
where id =169172;

COMMIT;
