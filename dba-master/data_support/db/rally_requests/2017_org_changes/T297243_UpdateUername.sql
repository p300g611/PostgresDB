BEGIN;

update student 
set username ='gabe'||'.'||'tjad',
    modifieddate = now(),
	modifieduser =12
where id = 1217296;


COMMIT;