BEGIN;


update student
set    username ='keegan.lyman',
       modifieddate=now(),
	   modifieduser =12
where id = 587866;

COMMIT;