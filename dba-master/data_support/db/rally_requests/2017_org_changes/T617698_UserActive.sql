BEGIN;

update aartuser
set    
	   uniquecommonidentifier='j.nazworth@siloisd.org',
	   modifieddate =now(),
	   modifieduser =12
where id =102531;


INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 102531             aartuserid,
                   34142               organizationid,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,			
            (select id from usersorganizations where aartuserid=102531 and organizationid =34140)       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;				   
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,			
            (select id from usersorganizations where aartuserid=102531 and organizationid =34142)       userorganizationid,
	                false               isdefault,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 107792 )
where id = 113566;	
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       102531                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
  (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=102531 and organizationid =34142) )    userorganizationsgroupsid;

update 	 userorganizationsgroups
set      status=1,
         activationno = '102531-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 107792;
		 
		 
update 	 userorganizationsgroups
set      status=1,
         activationno = '102531-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = (select id from usersorganizations where aartuserid=102531 and organizationid =34142);		 
		 

 COMMIT;