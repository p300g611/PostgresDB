BEGIN;

update aartuser
set  username =username||'_old',
     email =email||'_old',
	 uniquecommonidentifier =uniquecommonidentifier||'_old',
	 activeflag = false,
	 modifieddate =now(),
	 modifieduser =12
where id = 70051;


update aartuser
set  username='lmazzetta@williamsburg.k12.ia.us',
     email='lmazzetta@williamsburg.k12.ia.us',
	 uniquecommonidentifier='lmazzetta@williamsburg.k12.ia.us',
	 activeflag = true,
	 modifieddate =now(),
	 modifieduser =12
where id = 162988;  






COMMIT;