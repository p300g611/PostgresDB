BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =142599;


update userpdtrainingdetail
set userid = 165949,
    modifieddate = now(),
	modifieduser =12
where id = 24190;


COMMIT;