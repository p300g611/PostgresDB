BEGIN;

update usersorganizations
set isdefault = true,
    modifieddate= now(),
	modifieduser =12
where id  = 75539;


update usersorganizations
set isdefault = false,
    activeflag =false,
    modifieddate= now(),
	modifieduser =12
where id  = 74773;

update usersorganizations
set isdefault = false,
    activeflag =false,
    modifieddate= now(),
	modifieduser =12
where id  = 199756;

update 	 userorganizationsgroups
set      activationno = '73493-'||id,
         status=1,
		 groupid = 9686,
		 activeflag =true,
		 isdefault=true,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
 where id =56948;
 
 
update userassessmentprogram
set    activeflag =false,
       isdefault=false,
	   modifieddate =now(),
	   modifieduser =12
where id = 422389;


update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12
where id = 236161;

COMMIT;
 
 