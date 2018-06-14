BEGIN;

update usersorganizations
set   isdefault = false,
       modifieddate=now(),
	   modifieduser =12
	where id = 50877;
	
	
update userassessmentprogram
set   isdefault = false,
       modifieddate=now(),
	   modifieduser =12
	where id = 209799;
	
COMMIT;