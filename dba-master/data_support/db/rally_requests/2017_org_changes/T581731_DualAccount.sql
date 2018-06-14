BEGIN;


UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   modifieddate =now(),
	   modifieduser =12
where id =85977;

COMMMIT;