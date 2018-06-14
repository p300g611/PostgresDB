BEGIN;

UPDATE enrollment 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id = 2451451;

update enrollmentsrosters 
set activeflag = false,
     modifieddate =now(),
	modifieduser =12
where id in (14695255,14695254);   


COMMIT;