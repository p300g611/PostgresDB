
BEGIN;

update usersorganizations
set organizationid = 46996,
    modifieddate= now(),
	modifieduser =12
where id  = 114682;


 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   114682              userorganizationid,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 114682 )
where id = 2510;					   


update 	 userorganizationsgroups
set      activationno = '108684-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
where userorganizationid = 114682;


COMMIT;