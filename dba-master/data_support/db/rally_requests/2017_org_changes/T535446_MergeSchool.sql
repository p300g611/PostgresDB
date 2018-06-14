BEGIN;

update organization
   set activeflag = false,
       modifieddate = now(),
	   modifieduser =12
	where id = 18202;
	
	
	
delete from organizationtreedetail 
   where schoolid = 18202;
   
 COMMIT;
 