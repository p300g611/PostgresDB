BEGIN;

update usersorganizations
set organizationid = 1902,
    modifieddate = now(),
	modifieduser =12
where id  = 7252;



update aartuser 
set   username = username||'_old',
      email = email||'_old',
	  uniquecommonidentifier=uniquecommonidentifier||'_old',
	  activeflag = false,
	  modifieddate=now(),
	  modifieduser =12
where id = 5853;


update usersorganizations
set activeflag =false,
    isdefault =false,
    modifieddate = now(),
	modifieduser =12
where id  = 5786;

commit;