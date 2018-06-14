BEGIN;

update usersorganizations
set organizationid = 39169,
    activeflag =true,
    modifieddate= now(),
	modifieduser =12
where id  = 184351;

/*
update 	 userorganizationsgroups
set      activationno = '162066-235202',
         status=1,
         groupid = 9687,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
 where id =235202;
 */
 COMMIT;