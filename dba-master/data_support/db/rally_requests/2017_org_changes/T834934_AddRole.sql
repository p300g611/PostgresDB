BEGIN;

update aartuser
set  
	   uniquecommonidentifier='porter@midwestcentral.org',
	   modifieddate =now(),
	   modifieduser =12
where id =116203;


update usersorganizations
set organizationid = 46436,
    modifieddate= now(),
	modifieduser =12
where id  = 123472;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DTC')  groupid,
                           1                                             status,
                    123472         userorganizationid,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 123472 )
where id = 99619;


update 	 userorganizationsgroups
set      activationno = '116203-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 123472;
		 
COMMIT;

		 

