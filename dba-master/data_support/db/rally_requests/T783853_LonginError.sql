BEGIN;

update aartuser
set    username='acarlson@usd397.com',
	   modifieddate =now(),
	   modifieduser =12
where id =167890;

COMMIT;


