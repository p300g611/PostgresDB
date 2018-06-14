BEGIN;

update aartuser
set    
	   uniquecommonidentifier='lspinka@okawvillek12.org',
	   modifieddate =now(),
	   modifieduser =174744
where id =90971;



update usersorganizations
set organizationid = 47655,
    modifieddate= now(),
	modifieduser =174744
where id  = 94276;




INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='PRN')  groupid,
                           1                                             status,
                   94276      userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   174744                 createduser,
                   now()              modifieddate,
                   174744                 modifieduser, 
                   true               activeflag;
				   
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =174744,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 94276 )
where id = 98787;



update 	 userorganizationsgroups
set      activationno = '90971-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =174744
 where userorganizationid = 94276;	


COMMIT;
 