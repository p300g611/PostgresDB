BEGIN;

update aartuser
set    username='jenni.scherschel@wces.co',
       email='jenni.scherschel@wces.co',
	   modifieddate =now(),
	   modifieduser =12
where id =84301;


update usersorganizations
set organizationid = 48914,
    modifieddate= now(),
	modifieduser =12
where id  = 86852;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                 86852        userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 86852 )
where id =1962;

COMMIT;