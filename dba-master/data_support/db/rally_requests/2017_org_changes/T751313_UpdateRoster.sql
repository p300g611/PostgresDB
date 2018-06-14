BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   modifieddate =now(),
	   modifieduser =12
where id =58984;


update aartuser
set    
	   uniquecommonidentifier='5549934124',
	   modifieddate =now(),
	   modifieduser =12
where id =168237;


COMMIT;

