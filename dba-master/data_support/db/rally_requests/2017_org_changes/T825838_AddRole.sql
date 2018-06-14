BEGIN;
update aartuser
   set
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag = false,
	   modifieddate = now(),
	   modifieduser = 12
	where id  = 18297;
	
	
	  
insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 116446            aartuserid,
                   2328              organizationid,
                   false             isdefault,
                   now()             createddate,
                   12                createduser,
                   now()             modifieddate,
                   12                modifieduser, 
                   true              activeflag;	  
	
insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 116446            aartuserid,
                   2330              organizationid,
                   false             isdefault,
                   now()             createddate,
                   12                createduser,
                   now()             modifieddate,
                   12                modifieduser, 
                   true              activeflag;

				   
insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 116446            aartuserid,
                   2326              organizationid,
                   false             isdefault,
                   now()             createddate,
                   12                createduser,
                   now()             modifieddate,
                   12                modifieduser, 
                   true              activeflag;
				   
 	
			   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='BTC')  groupid,
                           2                                             status,
               (select id from usersorganizations where aartuserid =116446 and organizationid=2330)  userorganizationid,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='BTC')  groupid,
                           2                                             status,
               (select id from usersorganizations where aartuserid =116446 and organizationid=2328)  userorganizationid,
			   false                                          isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
			   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='BTC')  groupid,
                           2                                             status,
               (select id from usersorganizations where aartuserid =116446 and organizationid=2326)  userorganizationid,
			   false                                          isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       116446                                   aartuserid,
              (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
               true                                       activeflag,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = (select id from usersorganizations where aartuserid =116446 and organizationid=2330))   userorganizationsgroupsid;
		
		
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       116446                                   aartuserid,
              (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
               true                                       activeflag,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = (select id from usersorganizations where aartuserid =116446 and organizationid=2328))   userorganizationsgroupsid;
			   
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       116446                                   aartuserid,
              (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
               true                                       activeflag,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = (select id from usersorganizations where aartuserid =116446 and organizationid=2326))   userorganizationsgroupsid;
			   

			   
COMMIT;