BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =37477;



update aartuser
set    username='klesser@olatheschools.org',
       email='klesser@olatheschools.org',
	   uniquecommonidentifier='7325424221',
	   modifieddate =now(),
	   modifieduser =12
where id =164495;


update roster 
set teacherid = 164495,
	   modifieddate =now(),
	   modifieduser =12
where id in (1080421,1079305,1055484,893324,893325,893326);


update userpdtrainingdetail
set userid = 164495,
	   modifieddate =now(),
	   modifieduser =12
where id in (3418,506);


COMMIT;