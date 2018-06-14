BEGIN;

update aartuser
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id  =63583;



update aartuser
set    username='johnnyeburtt@twinfield.net',
       email='johnnyeburtt@twinfield.net',
	   uniquecommonidentifier='johnnyeburtt@twinfield.net',
	   modifieddate =now(),
	   modifieduser =12
where id  =165163;

COMMIT;