BEGIN;

update enrollment
set    activeflag = true,
       modifieddate=now(),
	   modifieduser= 12
	where id =2672280;
	
COMMIT;