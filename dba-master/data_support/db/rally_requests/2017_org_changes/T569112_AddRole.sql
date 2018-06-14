BEGIN;

update aartuser
set    username=username||'_old',
       email=email||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id  =87142;



update aartuser
set    username='cmeehan@lrhsd.org',
       email='cmeehan@lrhsd.org',
	   modifieddate =now(),
	   modifieduser =12
where id  =166536;

COMMIT;