BEGIN;

update aartuser 
  set username=username||'_old',
      email =email||'_old',
	  uniquecommonidentifier =uniquecommonidentifier||'_old',
	  activeflag = false,
	  modifieddate =now(),
	  modifieduser =12
	where id = 122718;
	
update aartuser 
  set 
	  uniquecommonidentifier ='9519292519',
	  modifieddate =now(),
	  modifieduser =12
	where id = 164499;
	
update usersorganizations
   set isdefault = false,  
       activeflag = false, 
	   modifieddate =now(),
	   modifieduser = 12
	where id = 189592;
	
update userassessmentprogram
   set activeflag = false, 
       modifieddate =now(),
	   modifieduser =12
	where id = 402169;
	
COMMIT;
