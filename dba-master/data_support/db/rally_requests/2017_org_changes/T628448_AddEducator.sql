BEGIN;

update aartuser 
set username=username||'_old',
    email=email||'_old',
	activeflag =false,
	modifieddate=now(),
	modifieduser =12
where id = 162922;


update aartuser 
set username='mrailsback@usd107.org',
    email='mrailsback@usd107.org',
	modifieddate=now(),
	modifieduser =12
where id = 99318;

COMMIT;