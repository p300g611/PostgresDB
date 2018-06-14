BEGIN;

update aartuser
 set username = username||'_old',
     email = email||'_old',
	 activeflag = false,
	 modifieddate = now(),
	 modifieduser =12
	where id = 71920 and activeflag is true;
	
	
	
update aartuser
 set username ='dmoeller@benton.k12.ia.us',
     email = 'dmoeller@benton.k12.ia.us',
	 uniquecommonidentifier ='dmoeller@benton.k12.ia.us',
	 modifieddate = now(),
	 modifieduser =12
	where id = 163106; 
	
	
COMMIT;