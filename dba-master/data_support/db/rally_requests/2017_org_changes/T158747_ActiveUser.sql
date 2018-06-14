BEGIN;

update aartuser
set activeflag = true,
    modifieddate= now(),
	modifieduser =12
where id = 143904;

COMMIT;