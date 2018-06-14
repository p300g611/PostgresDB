BEGIN;

update aartuser
set    username='tcmhenderson@eldoradoschools.org',
       email='tcmhenderson@eldoradoschools.org',
	   modifieddate =now(),
	   modifieduser =12
where id =161766;


update usersorganizations
set activeflag =false,
    isdefault =false,
    modifieddate= now(),
	modifieduser =12
where id  = 183680;


update userorganizationsgroups
set    status=2,
	   modifieddate= now(),
	   modifieduser =12
where id= 233941;


update  userassessmentprogram
set     isdefault=false,
	   modifieddate= now(),
	   modifieduser =12
where id= 233941;


INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 161766             aartuserid,
                   6049               organizationid,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='BTC')  groupid,
                           1                                             status,
            (select id from usersorganizations where aartuserid=161766 and organizationid =6049)       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       161766                                   aartuserid,
                     47        assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=161766 and organizationid =6049) )    userorganizationsgroupsid;	

			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       161766                                   aartuserid,
                     12           assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=161766 and organizationid =6049) )    userorganizationsgroupsid;	


update 	 userorganizationsgroups
set      activationno = '161766-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = (select id from usersorganizations where aartuserid=161766 and organizationid =6049);		

COMMIT;		 