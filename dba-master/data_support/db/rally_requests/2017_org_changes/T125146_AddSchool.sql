begin;

update usersorganizations
set isdefault=true,
    modifieddate =now(),
	modifieduser =12
where id  = 140613;






update userassessmentprogram
set isdefault=false,
    modifieddate =now(),
	modifieduser =12
where id  = 403268;


commit;