BEGIN;

UPDATE aartuser
 set username = username||'_old',
     email = email||'_old',
	 activeflag =false,
	 modifieddate = now(),
	 modifieduser =12
  where id = 105561;
  
update aartuser 
 set email = 'jschimmel@d131.org',
     username ='jschimmel@d131.org',
	 uniquecommonidentifier ='jschimmel@d131.org'
  where id = 106735;
  
COMMIT;