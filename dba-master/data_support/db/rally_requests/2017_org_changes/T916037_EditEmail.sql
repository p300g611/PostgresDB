BEGIN;

update aartuser
set    username='gabriellenavickas@mooreschools.com',
       email='gabriellenavickas@mooreschools.com',
	   modifieddate =now(),
	   modifieduser =12
where id =166572;

COMMIT;
