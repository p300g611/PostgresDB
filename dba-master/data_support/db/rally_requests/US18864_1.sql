BEGIN;

update studentstests
set activeflag = true
	  ,modifieddate = now()
	  ,modifieduser = 12
where 	id = 12968778;



update studentstests 
set    activeflag = true
       ,modifieddate = now()
	   ,modifieduser = 12
where id = 13077637;

COMMIT;