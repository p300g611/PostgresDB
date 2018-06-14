BEGIN;

update aartuser 
set email='Kpaxson@argonia359.org',
    username='Kpaxson@argonia359.org',
    modifieddate= now(),
	modifieduser =12
where id = 3276;

COMMIT;