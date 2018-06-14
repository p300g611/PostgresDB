begin;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag = false,
	   modifieddate =now(),
	   modifieduser =12
where id =79991;


update aartuser 
set username ='horrella@capetigers.com',
    email ='horrella@capetigers.com',
	uniquecommonidentifier = 'horrella@capetigers.com',
	modifieddate = now(),
	modifieduser =12
where id = 66297;

COMMIT;