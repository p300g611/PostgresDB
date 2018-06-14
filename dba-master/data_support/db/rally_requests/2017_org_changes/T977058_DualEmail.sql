BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =174744
where id =64805;



update aartuser
set    username='ljustice@ctkkck.org',
       email='ljustice@ctkkck.org',
	   modifieddate =now(),
	   modifieduser =174744
where id =64239;


COMMIT;