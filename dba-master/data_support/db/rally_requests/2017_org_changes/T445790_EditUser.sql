Begin;

update usersorganizations
set isdefault = false, 
    modifieddate =now(),
	modifieduser =12
where id =189541;


update userorganizationsgroups
set isdefault =false,
    status =2,
    modifieddate =now(),
	modifieduser =12
where id =241906;


update userassessmentprogram 
set  isdefault =false,
    modifieddate =now(),
	modifieduser =12
where id =402081;

COMMIT;
