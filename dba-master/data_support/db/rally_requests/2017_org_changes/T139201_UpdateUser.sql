BEGIN;

update aartuser
set  username ='kfoss@trinityatchison.org',
     email ='kfoss@trinityatchison.org',
	 modifieddate = now(),
	 modifieduser =12
where id = 116041;


update usersorganizations
 set  organizationid = 2742,
	  modifieddate = now(),
	  modifieduser =12
where id = 123289;  

COMMIT;