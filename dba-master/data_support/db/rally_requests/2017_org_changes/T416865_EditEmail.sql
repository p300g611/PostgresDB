BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   modifieddate =now(),
	   modifieduser =12
where id in (15484,43161);


UPDATE aartuser 
set    username='emily.reed@usd453.org',
       email='emily.reed@usd453.org',
	   modifieddate =now(),
	   modifieduser =12
where id =158133;


UPDATE aartuser 
set    username='michaela.heath@usd453.org',
       email='michaela.heath@usd453.org',
	   modifieddate =now(),
	   modifieduser =12
where id =158080;


COMMIT;
