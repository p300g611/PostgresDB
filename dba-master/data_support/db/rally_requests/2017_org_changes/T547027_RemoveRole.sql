BEGIN;



update usersorganizations
set isdefault = false,
    activeflag = false,
    modifieddate = now(),
	modifieduser =12
where id  = 144953;

update usersorganizations
set organizationid = 18600,
    modifieddate = now(),
	modifieduser =12
where id  = 57643;


update userorganizationsgroups
set activeflag = false,
	modifieddate = now(),
	modifieduser =12
where id in (38386,38385,35771);
	   
			   
COMMIT;