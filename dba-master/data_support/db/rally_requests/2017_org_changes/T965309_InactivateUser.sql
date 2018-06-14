BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =174744
where id =11172;


update aartuser
set   
	   uniquecommonidentifier='5149892955',
	   modifieddate =now(),
	   modifieduser =174744
where id =127412;

COMMIT;