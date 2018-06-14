BEGIN;

update student 
set    activeflag =false,
       modifieddate =now(),
	   modifieduser=12
where id =224907; 

update student 
set    username ='conn.prin',
       modifieddate =now(),
	   modifieduser=12
where id =676598; 


COMMIT;