BEGIN;

update student 
set username ='cole.stea',
    modifieddate = now(),
	modifieduser =12
where id = 1323976;

COMMIT;