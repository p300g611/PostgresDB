BEGIN;

UPDATE aartuser 
  set uniquecommonidentifier =uniquecommonidentifier||'_old',
      email = email||'_old',
	  username = username||'_old',
      modifieddate = now(),
	  modifieduser =12
where uniquecommonidentifier = '922653';

update usersorganizations
    set activeflag = false,
	modifieddate =now(),
	modifieduser =12
where id = 60825 and activeflag is true;



update userassessmentprogram 
  set activeflag = false,
	modifieddate =now(),
	modifieduser =12
where id = 222529 and activeflag is true;

update userorganizationsgroups 
set activeflag = false,
	modifieddate =now(),
	modifieduser =12
where id = 39361 and activeflag is true;


COMMIT;

