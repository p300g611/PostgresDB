BEGIN;

update aartuser
set    username='ahoskins@abileneschools.org',
       email='ahoskins@abileneschools.org',
	   uniquecommonidentifier='4469168726',
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =12
where id =28957;

update usersorganizations
set   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =162241;

update userassessmentprogram
set    activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id = 346599;

COMMIT;