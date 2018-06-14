BEGIN;



UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =107876;


update aartuser
set    username='swilson@sasabilene.com',
       email='swilson@sasabilene.com',
	   modifieddate =now(),
	   modifieduser =12
where id =111314;

COMMIT;