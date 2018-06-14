BEGIN;

update student
set    statestudentidentifier ='1002363141',
       modifieddate =now(),
	   modifieduser =174744
where id =1409220;


update student
set    statestudentidentifier ='1002185652',
       modifieddate =now(),
	   modifieduser =174744
where id =1409219;


COMMIT;
