BEGIN;

update aartuser
set   
	   uniquecommonidentifier='2846342628',
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =35406;


update usersorganizations
set activeflag =true,
    organizationid = 82786,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  =35339;


update userorganizationsgroups
set    activeflag =false,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  in (98327,14580);



update userassessmentprogram
set   activeflag =false,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  in (255462,199772);


COMMIT;
