BEGIN;

update usersorganizations
set organizationid = 5645,
    activeflag =true,
    modifieddate= now(),
	modifieduser =12
where id  = 34140; 

update 	 userorganizationsgroups
set      status=1,
         activationno = '34207-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where id =13381;
COMMIT;