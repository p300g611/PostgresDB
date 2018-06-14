BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =174744
where id =115840;


update aartuser
set    username='ejpimentel@cps.edu',
       email='ejpimentel@cps.edu',
	   modifieddate =now(),
	   modifieduser =174744
where id =178870;

COMMIT;