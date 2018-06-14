BEGIN;

update usersorganizations
set organizationid = 3136,
    activeflag =true,
    modifieddate= now(),
	modifieduser =174744
where id  = 54606;



INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='BTC')  groupid,
                           1                                             status,
                    54606          userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   174744                 createduser,
                   now()              modifieddate,
                   174744                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       54714                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   174744                 createduser,
                   now()              modifieddate,
                   174744                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =54606 )    userorganizationsgroupsid;



update 	 userorganizationsgroups
set      activationno = '54714-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =174744
		 where userorganizationid = 54606;
		 
		 
COMMIT; 