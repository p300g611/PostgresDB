BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    127283     userorganizationid,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 127283 )
where id = 102717;


update 	 userorganizationsgroups
set      activationno = '119381-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =174744
		 where userorganizationid = 127283;
		 
commit;